class Voteaward::Vote < ActiveRecord::Base
  self.table_name = 'voteaward_votes'
  belongs_to :voteaward_election, class_name: "Voteaward::Election", foreign_key: "voteaward_election_id"
  belongs_to :voteaward_user, class_name: "Voteaward::User", foreign_key: "voteaward_user_id"
  has_many :voteaward_comments, class_name: "Voteaward::Comment", as: :commentable

  mount_uploader :image_filename, VoteawardImageUploader

  default_scope { order("id desc") }
end
