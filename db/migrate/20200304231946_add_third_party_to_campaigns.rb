class AddThirdPartyToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :confirm_third_party, :datetime, default: nil, after: :confirm_privacy
  end
end