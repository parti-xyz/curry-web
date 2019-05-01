class ChangeUseSignerPhoneOfCampaigns < ActiveRecord::Migration[5.0]
  def up
    add_column :campaigns, :use_signer_phone_string, :string, default: 'unused'
    transaction do
      Campaign.where(use_signer_phone: true).update_all(use_signer_phone_string: 'required')
    end
    remove_column :campaigns, :use_signer_phone
    rename_column :campaigns, :use_signer_phone_string, :use_signer_phone
  end

  def down
    add_column :campaigns, :use_signer_phone_boolean, :boolean, default: false
    transaction do
      Campaign.where.not(use_signer_phone: 'unused').update_all(use_signer_phone_boolean: true)
    end
    remove_column :campaigns, :use_signer_phone
    rename_column :campaigns, :use_signer_phone_boolean, :use_signer_phone
  end
end
