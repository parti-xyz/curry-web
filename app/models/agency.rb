class Agency < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  mount_uploader :image, ImageUploader
  has_many :action_targets, as: :action_assignable

  has_and_belongs_to_many :positions, -> { distinct }
  has_many :agents, through: :positions

  before_save :build_positions_by_position_name_list

  def related_campaigns
     Campaign.joins(:dedicated_agents).where('agents.id': self.agents).distinct
     .union_all(id: ActionTarget.where(action_assignable: self).select(:action_targetable_id)).order(id: :desc)
  end

  # action_assignable interface
  def statementable_agents()
    agents
  end

  def statementable_agents_moderatly(limit)
    result = agents
    if result.count > limit
      result.order("RAND()").first(limit)
    else
      result
    end
  end

  def section_title_as_action_assignable
    title
  end

  def response_section_title_as_action_assignable
    I18n.t("views.action_assignable.agent_section_response_title.custom", title: title)
  end

  def agents_unspoken_limit
    30
  end

  def self.assembly_20th
    Agency.find_by(slug: 'assembly_20th')
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

  def build_positions_by_position_name_list
    if @_position_name_list_touched
      rebuilding_position_names = []
      if @_position_name_list.present?
        rebuilding_position_names = @_position_name_list.split(',').map(&:strip)
      end

      rebuilding_positions = Position.named(*rebuilding_position_names).to_a

      self.positions.where.not(id: rebuilding_positions).each  do |position|
        self.positions.delete(position)
      end
      rebuilding_positions.each do |position|
        if !self.positions.exists?(id: position)
          positions << position
        end
      end
    end
    @_position_name_list_touched = false
  end
end
