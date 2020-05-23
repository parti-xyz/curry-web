if ENV['SIDEKIQ'] == "true" or (!Rails.env.development? && !Rails.env.test?)
  if Rails.env.production? && ENV['REDIS_HOST'].present? && ENV['REDIS_PORT'].present?
    redis_config = {
      url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}",
      namespace: "campaigns:#{Rails.env}"
    }
  else
    redis_config = {
      namespace: "govcraft:#{Rails.env}"
    }
  end

  Sidekiq.configure_server do |config|
    config.redis = redis_config
  end
  Sidekiq.configure_client do |config|
    config.redis = redis_config
  end

  schedule_file = "config/schedule.yml"

  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
  end
else
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
