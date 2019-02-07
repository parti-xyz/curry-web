class UpdateCommentsCountOfCampaigns < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          Campaign.all.each do |campaign|
            campaign.update_column(:comments_count, campaign.comments.count)
          end
        end
      end

      dir.down do
        transaction do
          Campaign.all.each do |campaign|
            campaign.update_column(:comments_count, 0)
          end
        end
      end
    end
  end
end
