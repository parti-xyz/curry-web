class Voteaward::Award < ActiveRecord::Base
  self.table_name = 'voteaward_awards'
  serialize :promise_ids, Array
  belongs_to :voteaward_election, class_name: "Voteaward::Election", foreign_key: "voteaward_election_id"
  belongs_to :voteaward_user, class_name: "Voteaward::User", foreign_key: "voteaward_user_id"

  default_scope { order("id desc") }
end
