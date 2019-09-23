class AddConfirmPrivacyToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :confirm_privacy, :boolean, default: false
  end
end
