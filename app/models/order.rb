class Order < ApplicationRecord
  belongs_to :comment, counter_cache: true
  belongs_to :agent

  scope :all_read, -> { where.not(read_at: nil) }
  scope :recent, -> { order('created_at DESC').order('id DESC') }

  def read?
    self.read_at.present?
  end
end
