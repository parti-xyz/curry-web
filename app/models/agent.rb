class Agent < ApplicationRecord

  has_many :opinions, dependent: :destroy
  has_many :sent_requests, dependent: :destroy
  has_many :agenda_documents, dependent: :destroy
  has_many :election_candidates, dependent: :nullify
  has_and_belongs_to_many :campaigns, -> { distinct }
  has_many :appointments, dependent: :destroy
  has_many :positions, through: :appointments
  has_many :agencies, -> { distinct }, through: :positions
  has_many :orders, dependent: :destroy

  extend Enumerize
  enumerize :category, in: %i(개인 법인)

  validates :name, presence: true
  validates :category, presence: true
  mount_uploader :image, ImageUploader

  before_save :build_appointments_by_position_name_list

  scope :of_position_names, ->(*position_names) { where(id: Appointment.of_positions_named(position_names).select(:agent_id)) }
  scope :of_positions, ->(*positions) { where(id: Appointment.of_positions(positions).select(:agent_id)) }
  scoped_search on: [:name]

  def self.popular_limit(limit)
    result = self.popular_orders.limit(limit).to_a
    result += self.popular_campaigns.limit(limit - result.count).to_a

    result
  end

  def self.popular_campaigns
    self.joins(:campaigns).group("agents_campaigns.id").order("count(agents_campaigns.id) desc")
  end

  def self.popular_orders
    self.joins(:orders).where('orders.created_at > ?', Order.last.created_at.ago(7.days)).group("orders.agent_id").order("count(orders.agent_id) desc").having("count(orders.agent_id) > 0")
  end

  def related_campaigns
     self.campaigns.union_all(id: ActionTarget.where(action_assignable: self.agencies).select(:action_targetable_id)).order(id: :desc)
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

  def position_name_list
    return @_position_name_list if @_position_name_list.present?

    @_position_name_list = positions.map(&:name).join(', ')
    @_position_name_list
  end

  def position_name_list=(names)
    @_position_name_list_touched = true
    @_position_name_list = names
  end

  def build_appointments_by_position_name_list
    if @_position_name_list_touched
      rebuilding_position_names = []
      if @_position_name_list.present?
        rebuilding_position_names = @_position_name_list.split(',').map(&:strip)
      end

      rebuilding_positions = Position.named(*rebuilding_position_names).to_a

      self.appointments.where.not(position: rebuilding_positions).destroy_all
      rebuilding_positions.each do |position|
        if !self.appointments.exists?(position: position)
          self.appointments.build(position: position)
        end
      end
    end
    @_position_name_list_touched = false
  end
end
