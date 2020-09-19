class Statement < ApplicationRecord
  belongs_to :agent
  belongs_to :statementable, polymorphic: true, optional: true
  belongs_to :last_updated_user, optional: true, class_name: 'User'
  has_many :statement_keys

  extend Enumerize
  enumerize :stance, in: %i(agree disagree unsure)
  validates :stance, presence: true

  scope :recent, -> { order('updated_at DESC').order('id DESC') }
  scope :sure_stance, -> { where.not(stance: 'unsure') }
  scope :responded_only, -> { sure_stance.or(any_body) }
  scope :agreed, -> { where(stance: :agree) }
  scope :disagreed, -> { where(stance: :disagree) }
  scope :any_body, -> { where.not(body: nil).where.not(body: "") }

  def is_responded?
    sure? or body.present?
  end

  def sure?
    (stance.present? and !stance.unsure?)
  end

  def unsure?
    !sure?
  end

  def valid_key? key
    statement_keys.exists?(key: key) and !statement_keys.find_by(key: key).expired?
  end

  def stancable?
    return false if !statementable.respond_to?(:stancable?)
    statementable.stancable?
  end

  def respond_status?(*status)
    status.try(:compact!)
    return false if status.blank?
    status.map(&:to_sym).include?(self.respond_status.try(:to_sym))
  end

  def respond_status
    if statementable.try(:need_stance?)
      self.stance.try(:value).try(:to_sym)
    else
      self.body.present? ? :any_body : :unsure
    end
  end

  def individually_orderable?
    !respond_status?(:agree, :any_body)
  end
end
