# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://campaigns.kr"

SitemapGenerator::Sitemap.create do
  Campaign.find_each do |campaign|
    add campaign_path(campaign), lastmod: campaign.updated_at
  end
end
