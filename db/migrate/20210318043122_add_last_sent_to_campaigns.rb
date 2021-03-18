class AddLastSentToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :lastsent_at, :datetime
    add_column :campaigns, :use_sample_mail, :boolean
  end
end
