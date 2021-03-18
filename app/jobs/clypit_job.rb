require 'json'
require 'rest-client'
require 'open-uri'

class ClypitJob
  include Sidekiq::Worker
  sidekiq_options lock: :while_executing, lock_timeout: 0, on_conflict: :raise, retry: 8

  def perform
    document = ArchiveDocument.left_outer_joins(:clypit).find_by(media_type: '음성', clypits: { id: nil })
    return if document.blank?

    if document.read_attribute(:content).blank?
      logger.info("Document ##{document.id} : no content")
      return
    end

    begin
      @data = nil
      if document.content.file.respond_to?(:url)
        Dir.mktmpdir do |dir|
          temp_file = "#{dir}/#{document.content_name}"
          open(temp_file, 'wb') do |f|
            f << open(document.content.url).read
          end

          extname = File.extname(temp_file)
          unless %w(.mp3 .ogg .m4a .wav .aiff .aif .3gpp).include? extname
            new_temp_file = "#{dir}/#{File.basename(temp_file)}.wav"
            FFMPEG::Movie.new(temp_file).transcode(new_temp_file)
            temp_file = new_temp_file
          end
          @data = open temp_file
        end
      else
        @data = open document.content.path
      end

      if @data.nil?
        logger.info("Document ##{document.id} : no content data")
        return
      end

      begin
        auth_response = RestClient.post("https://api.clyp.it/oauth2/token",
          {
            grant_type: 'password',
            username: ENV['CLYPIT_USERNAME'],
            password: ENV['CLYPIT_PASSWORD']
          },
          {Authorization: 'Basic MjkzMTE5Og=='}
        )

        auth = JSON.parse(auth_response.body)
        if auth['error'].present?
          logger.info("Clypit Auth fail : #{auth['error']}")
          return
        end
        access_token = auth['access_token']
        if access_token.blank?
          logger.info("Clypit Auth fail : no access_token")
          return
        end
      rescue RestClient::ExceptionWithResponse => e
        logger.info("Clypit Auth fail : ")
        logger.info e.inspect
        logger.info e.response
      end

      begin
        upload_response = RestClient.post("https://upload.clyp.it/upload",
          {
            audioFile: @data,
            description: "#{document.title} #{Rails.application.routes.url_helpers.archive_document_url(document)}"
          },
          {
            'X-Client-Type': 'WebAlfa',
            'Authorization': "Bearer #{access_token}"
          }
        )

        upload_result = JSON.parse(upload_response.body)
        if upload_result["Successful"]
          document.build_clypit(audio_file_id: upload_result["AudioFileId"])
        else
          logger.info("Clypit Upload fail : #{upload_result['Title']} - #{upload_result['Description']}")
          document.build_clypit
        end
      rescue RestClient::ExceptionWithResponse => e
        logger.info("Clypit Upload fail : ")
        logger.info e.inspect
        logger.info e.response
      end

      document.save!
    ensure
      if document.clypit.blank?
        document.build_clypit
        document.save!
      end
    end
  end
end
