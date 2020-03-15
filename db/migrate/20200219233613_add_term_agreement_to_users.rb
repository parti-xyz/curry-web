class AddTermAgreementToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :term_service, :boolean, default: false
    add_column :users, :term_privacy, :boolean, default: false
    add_column :users, :term_marketing, :boolean, default: false
  end
end
