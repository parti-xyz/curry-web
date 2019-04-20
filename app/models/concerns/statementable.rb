module Statementable
  extend ActiveSupport::Concern

  included do
    has_many :statements, as: :statementable
    has_and_belongs_to_many :dedicated_agents, -> { distinct }, class_name: 'Agent'
    has_many :action_targets, dependent: :destroy, as: :action_targetable

    scope :to_action_assignable, ->(action_assignable) {
      where(id:
        ActionTarget
          .where(action_assignable: action_assignable)
          .with_action_targetable_type(self)
          .select(:action_targetable_id)
      )
    }
  end

  def agents_shuffled
    agents.order("RAND()")
  end

  def agents(action_assignable = nil)
    if action_assignable == nil
      if action_targets.blank?
        dedicated_agents
      else
        conditions = action_targets.map { |action_target|
          Agent.where(id: action_target.action_assignable.statementable_agents) }
        conditions << Agent.where(id: dedicated_agents)
        Agent.where.any_of(*conditions)
      end
    else
      action_assignable.statementable_agents
    end
  end

  def need_to_order_agents_shuffled
    need_to_order_agents.order("RAND()")
  end

  def need_to_order_agents(action_assignable = nil)
    not_agree_agents(action_assignable)
  end

  def not_agree_agents(action_assignable = nil)
    result = agents.where.not(id: statements.agreed.select(:agent_id))
    result = result.where(id: action_assignable.statementable_agents) if action_assignable.present?
    result
  end

  def unsure_agents(action_assignable = nil)
    result = agents.where.not(id: statements.sure.select(:agent_id))
    result = result.where(id: action_assignable.statementable_agents) if action_assignable.present?
    result
  end

  def sure_agents(action_assignable = nil)
    result = agents.where(id: statements.sure.select(:agent_id))
    result = result.where(id: action_assignable.statementable_agents) if action_assignable.present?
    result
  end

  def responded_agents(action_assignable = nil)
    result = agents.where(id: statements.responded_only.select(:agent_id))
    result = result.where(id: action_assignable.statementable_agents) if action_assignable.present?
    result
  end

  def reacted_agents_count
    self.statements.group(:stance).count['agree'] || 0
  end

  def no_reaction_agents_count
    agree_count = self.reacted_agents_count
    result = agents.count - agree_count
    result = 0 if result <= 0

    result
  end

  def agents_random(limit)
    agents.order("RAND()").first(limit)
  end

  def assigned? agent
    agents.include? agent
  end

  def action_targeting? action_assignable
    action_targets.exists?(action_assignable: action_assignable)
  end

  def spoken? agent
    assigned?(agent) and statement_of(agent).try(:is_responded?)
  end

  def action_assignable_agents_spoken(action_assignable)
    action_assignable.statementable_agents.where(id: statements.responded_only.select(:agent_id))
  end

  def action_assignable_agents_unspoken(action_assignable)
    agents_unspoken = action_assignable.statementable_agents.where.not(id: statements.responded_only.select(:agent_id))
    if action_assignable.agents_unspoken_limit.present? and agents_unspoken.count > action_assignable.agents_unspoken_limit
      agents_unspoken = agents_unspoken.order("RAND()").first(action_assignable.agents_unspoken_limit)
    else
      agents_unspoken
    end
  end

  def statement_of agent
    statements.find_by(agent: agent)
  end

  def cached_statement_of agent
    if @__cached_statements.blank?
      @__cached_statements = statements.to_a
    end
    result = @__cached_statements.select { |statement| statement.agent_id == agent.id }.try(:first)
    return result if result.present?

    @__cached_statements = statements.to_a
  end

  def total_action_assignables
    action_targets.map(&:action_assignable) + [DedicatedActionAssignee.new(self)]
  end

  def total_section_title_as_action_assignables
    total_action_assignables.map(&:section_title_as_action_assignable).compact.join(', ')
  end

  def statementable?
    true
  end
end
