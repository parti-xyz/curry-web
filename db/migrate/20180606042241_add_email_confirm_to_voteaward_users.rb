class AddEmailConfirmToVoteawardUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :voteaward_users, :email_confirmed, :boolean, default: false
    add_column :voteaward_users, :email_confirmed_at, :datetime
    add_column :voteaward_users, :confirm_token, :string
  end
end
