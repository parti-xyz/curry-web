class CreateSignerEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :signer_emails do |t|
      t.string :title
      t.text :body
      t.boolean :draft, default: true
      t.references :user, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
