class EmailSubscription < ApplicationRecord
  belongs_to :mailerable, polymorphic: true
end
