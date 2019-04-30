class ChangeUseSignerAddressOfCampaigns < ActiveRecord::Migration[5.0]
  def up
    add_column :campaigns, :use_signer_address_string, :string, default: 'unused'
    transaction do
      Campaign.where(use_signer_address: true).update_all(use_signer_address_string: 'required')
    end
    remove_column :campaigns, :use_signer_address
    rename_column :campaigns, :use_signer_address_string, :use_signer_address
  end

  def down
    add_column :campaigns, :use_signer_address_boolean, :boolean, default: false
    transaction do
      Campaign.where.not(use_signer_address: 'unused').update_all(use_signer_address_boolean: true)
    end
    remove_column :campaigns, :use_signer_address
    rename_column :campaigns, :use_signer_address_boolean, :use_signer_address
  end
end
