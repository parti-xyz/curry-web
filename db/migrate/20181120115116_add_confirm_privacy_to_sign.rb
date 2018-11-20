class AddConfirmPrivacyToSign < ActiveRecord::Migration[5.0]
  def change
    add_column :signs, :confirm_privacy, :boolean

    reversible do |dir|
      dir.up do
        transaction do
          Sign.where(campaign: Campaign.where.not(confirm_privacy: nil)).update_all(confirm_privacy: true)
        end
      end
    end
  end
end
