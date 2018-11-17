class SignerEmail < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :campaign
end
