class AddStealthToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :stealthily, :boolean, default: false
  end
end
