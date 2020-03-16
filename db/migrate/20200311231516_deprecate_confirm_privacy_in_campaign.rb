class DeprecateConfirmPrivacyInCampaign < ActiveRecord::Migration[5.0]
  def change
    rename_column :campaigns, :confirm_privacy, :deprecated_confirm_privacy
    add_column :signs, :confirm_third_party, :datetime, default: nil, after: :confirm_privacy
  end
end
