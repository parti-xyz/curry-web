class ScoreJob
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed

  def perform
    ActiveRecord::Base.transaction do
      for_articles
    end
  end

  def for_articles
    result = Like.past_week.group(:likable_id).where(likable_type: 'Article').count
    result.each do |article_id, hot_score|
      article = Article.find_by id: article_id
      next if article.blank?
      article.update_columns(hot_score: hot_score, hot_scored_datestamp: Date.today.strftime('%Y%m%d'))
    end
  end
end
