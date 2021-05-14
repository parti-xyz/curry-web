class AddLastSampleToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :last_sample_at, :datetime
    add_column :campaigns, :use_sample_mail, :boolean
    add_column :campaigns, :sample_email, :string
  end
end
