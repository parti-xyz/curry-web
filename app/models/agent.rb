class Agent < ApplicationRecord
  has_many :opinions, dependent: :destroy
  validates :name, presence: true
  mount_uploader :image, ImageUploader

  include Positionable

  has_many :sent_requests, dependent: :destroy
  has_many :agenda_documents, dependent: :destroy
  has_many :election_candidates, dependent: :nullify
  has_and_belongs_to_many :campaigns, -> { distinct }
  has_many :appointments, dependent: :destroy
  has_many :positions, through: :appointments
  has_many :agencies, -> { distinct }, through: :positions
  extend Enumerize
  enumerize :category, in: %i(개인 법인)

  validates :category, presence: true

  # X_POSITION
  # scope :of_position, ->(*positions) { tagged_with(positions, on: :positions) }
  # acts_as_taggable_on :positions

  scope :of_position_names, ->(*position_names) { where(id: Appointment.of_positions_named(position_names).select(:agent_id)) }
  scope :of_positions, ->(*positions) { where(id: Appointment.of_positions(positions).select(:agent_id)) }
  scoped_search on: [:name]

  def self.popular
    joins(:campaigns).group("agents_campaigns.id").order("count(agents_campaigns.id) desc")
  end

  def details
    "#{name} - #{organization}"
  end

  def requested_by? someone
    return false if someone.blank?
    sent_requests.exists? user: someone
  end

  def has_opinion_of? agenda
    opinions.exists?(issue: agenda.issues)
  end

  def opinions_of_agenda agenda
    opinions.where(issue: agenda.issues)
  end

  def positions_of_agency agency
    return Position.none unless agency.respond_to?(:positions)
    positions.where(id: agency.positions)
  end

  def generate_access_token
    self.access_token = SecureRandom.hex(10)
    self.access_fail_count = 0
  end

  def clear_access_token
    self.access_token = nil
    self.access_fail_count = 0
  end

  def generate_refresh_access_token
    return if self.refresh_access_token_at.try(:'>', 2.days.ago)

    self.refresh_access_token = SecureRandom.hex(30)
    self.refresh_access_token_at = DateTime.now
  end

  def clear_refresh_access_token
    self.refresh_access_token = nil
    self.refresh_access_token_at = nil
  end
end
