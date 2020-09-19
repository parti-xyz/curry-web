class Vote < ApplicationRecord
  include Choosable

  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: true

  counter_culture :votable, :column_name => proc {|model| "#{model.choice}s_count" }

  validates :user, uniqueness: { scope: [:votable_id, :votable_type] }, if: proc { user.present? }

  scope :recent, -> { order('id DESC') }
end
