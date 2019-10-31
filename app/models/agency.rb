class Agency < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  mount_uploader :image, ImageUploader
  has_many :action_targets, as: :action_assignable

  include Positionable

  # X_POSITION
  # acts_as_taggable_on :positions
  has_and_belongs_to_many :positions, -> { distinct }
  has_many :agents, through: :positions

  # X_POSITION
  # def agents
  #   Agent.tagged_with(position_list, on: :positions, any: true)
  # end

  def related_campaigns

    agents.map { |a| a.campaigns }.flatten.uniq
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
end
