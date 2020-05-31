class AddGaIdToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :ga_id, :string
  end
end
