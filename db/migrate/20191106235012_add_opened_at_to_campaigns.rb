class AddOpenedAtToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :opened_at, :datetime

    reversible do |dir|
      dir.up do
        transaction do
          Campaign.all.each do |campaign|
            campaign.opened_at ||= campaign.created_at.to_date
            campaign.save!
          end
        end
      end
    end
  end
end
