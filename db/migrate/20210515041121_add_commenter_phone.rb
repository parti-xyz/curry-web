class AddCommenterPhone < ActiveRecord::Migration[5.2]
  def change
    add_column(:campaigns, :commenter_phone_title, :string)
    add_column(:campaigns, :use_commenter_phone, :string, default: 'unused')
    add_column(:comments, :commenter_phone, :string)
  end
end
