class ChangeUseSignerEmailOfCampaigns < ActiveRecord::Migration[5.0]
  class Campaign < ActiveRecord::Base
  end

  def up
    rename_column :campaigns, :use_signer_email, :deprecated_use_signer_email
    add_column :campaigns, :use_signer_email, :string, default: 'unused'

    Campaign.where(deprecated_use_signer_email: true).update_all(use_signer_email: 'required')

    remove_column :campaigns, :deprecated_use_signer_email
  end
  #[:unused, :required, :optional]

  def down
    rename_column :campaigns, :use_signer_email, :deprecated_use_signer_email
    add_column :campaigns, :use_signer_email, :string, default: false

    Campaign.where.not(deprecated_use_signer_email: 'unused').update_all(use_signer_email: true)

    remove_column :campaigns, :deprecated_use_signer_email
  end
end
