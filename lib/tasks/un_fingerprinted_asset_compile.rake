require 'pathname'

# Every time assets:precompile is called, trigger umlaut:create_non_digest_assets afterwards.
Rake::Task["assets:precompile"].enhance do
  Rake::Task["parti:create_non_digest_assets"].invoke
end

namespace :parti do
  # This seems to be basically how ordinary asset precompile
  # is logging, ugh.
  logger = Logger.new($stderr)

  logger.info "Start Nondigested Precompile"

  # Based on suggestion at https://github.com/rails/sprockets-rails/issues/49#issuecomment-20535134
  # but limited to files in umlaut's namespaced asset directories.
  task :create_non_digest_assets => :"assets:environment"  do
    manifest_path = Dir.glob(File.join(Rails.root, 'public/assets/.*manifest-*.json')).first
    manifest_data = JSON.load(File.new(manifest_path))

    manifest_data["assets"].each do |logical_path, digested_path|
      logical_pathname = Pathname.new logical_path

      logger.info logical_pathname
      logger.info logical_path
      logger.info digested_path

      if ['widgets/v1/*'].any? {|testpath| logical_pathname.fnmatch?(testpath, File::FNM_PATHNAME) }
        full_digested_path    = File.join(Rails.root, 'public/assets', digested_path)
        full_nondigested_path = File.join(Rails.root, 'public/assets', logical_path)

        logger.info "(Nondigested) Copying to #{full_nondigested_path}"

        # Use FileUtils.copy_file with true third argument to copy
        # file attributes (eg mtime) too, as opposed to FileUtils.cp
        # Making symlnks with FileUtils.ln_s would be another option, not
        # sure if it would have unexpected issues.
        FileUtils.copy_file full_digested_path, full_nondigested_path, true

        logger.info full_digested_path
        logger.info full_nondigested_path

        "widgets/v1/campaign.js"
      end
    end

  end
end