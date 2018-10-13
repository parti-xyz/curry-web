class CreateEmailSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :email_subscriptions do |t|
      t.string :email
      t.boolean :use
      t.references :mailerable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
