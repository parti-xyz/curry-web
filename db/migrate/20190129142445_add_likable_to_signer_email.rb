class AddLikableToSignerEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :signer_emails, :likes_count, :integer, default: 0
    add_column :signer_emails, :anonymous_likes_count, :integer, default: 0
  end
end
