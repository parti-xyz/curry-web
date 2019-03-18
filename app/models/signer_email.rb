class SignerEmail < ApplicationRecord
  include Likable
  belongs_to :user, optional: true
  belongs_to :campaign

  scope :recent, -> { order(created_at: :desc) }
end
