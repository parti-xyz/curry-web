
class OkJob
  include Sidekiq::Worker

  def perform
    raise "TEST"
  end
end