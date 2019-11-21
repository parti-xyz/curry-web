class SpeechesViewCountJob
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed

  def perform
    Speech.where(is_expired_view_count: true).each do |speech|
      speech.update_columns cached_view_count: VideoInfo.new(speech.video_url).view_count,
        is_expired_view_count: false,
        view_count_cached_at: DateTime.now
      sleep(1.0/2.0)
    end
  end
end
