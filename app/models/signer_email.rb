class SignerEmail < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
end
