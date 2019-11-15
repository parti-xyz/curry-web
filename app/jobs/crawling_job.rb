class CrawlingJob
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed

  def perform(id)
    source = Article.find_by(id: id)
    return unless source.present?

    10.times do
      break if crawl!(source)
      sleep(1.0/2.0)
    end
  end

  def crawl!(source)
    data = fetch_data(source)
    return false unless valid_open_graph?(data)

    source.set_crawling_data(data)
    source.save!
  end

  def fetch_data(source)
    OpenGraph.new(source.url)
  end

  def valid_open_graph?(data)
    data.present? and data.title.present? and data.title != data.src
  end
end
