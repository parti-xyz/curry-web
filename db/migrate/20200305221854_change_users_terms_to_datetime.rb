class ChangeUsersTermsToDatetime < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :term_service, :boolean
    remove_column :users, :term_privacy, :boolean
    remove_column :users, :term_marketing, :boolean
    add_column :users, :term_service, :datetime, default: nil
    add_column :users, :term_privacy, :datetime, default: nil
    add_column :users, :term_privacy_must, :datetime, default: nil
    add_column :users, :term_privacy_option, :datetime, default: nil
    add_column :users, :term_marketing, :datetime, default: nil
  end
end