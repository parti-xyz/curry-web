class SignerEmail < ApplicationRecord
  include Likable
  belongs_to :user, optional: true
  belongs_to :campaign
end
