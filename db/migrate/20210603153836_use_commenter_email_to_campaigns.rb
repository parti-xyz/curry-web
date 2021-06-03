class UseCommenterEmailToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column(:campaigns, :commenter_email_title, :string)
    add_column(:campaigns, :use_commenter_email, :string, default: 'unused')
  end
end
