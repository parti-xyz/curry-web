class PartiHightlightPostsJob
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed

  def perform
    highlight_posts = RestClient.get "https://parti.xyz/api/v1/groups/kdemo/highlight_posts?limit=10"
    Rails.cache.write "urimanna_parti_highlight_posts", JSON.parse(highlight_posts.body)
  end
end
