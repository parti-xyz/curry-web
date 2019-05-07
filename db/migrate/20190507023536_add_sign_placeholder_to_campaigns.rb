class AddSignPlaceholderToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :sign_placeholder, :string
  end
end
