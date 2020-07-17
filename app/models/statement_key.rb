class StatementKey < ApplicationRecord
  belongs_to :statement

  validates :key, presence: true
  validates :expired_at, presence: true

  before_validation :init_expired_at

  def expired?
    expired_at == nil or expired_at < DateTime.now
  end

  def reusable?
    expired_at >= (24 * 7 - 2).hours.since
  end

  private

  def init_expired_at
    self.expired_at ||= (24 * 7).hours.since
  end
end
