class CommentToAgentJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing,
    batch_flush_size: 300 * 20,
    batch_flush_interval: 60 * 5,
    retry: 5

  def perform(grouping_params)
    payload_map = {}
    (grouping_params.is_a?(Hash) ? [grouping_params] : grouping_params.flatten).group_by do |params|
      comment = Comment.find_by(id: params["comment_id"])
      comment.try(:commentable)
    end.map do |commentable, params_items|
      [
        commentable,
        params_items.group_by do |params|
          order = Order.find_by(id: params["order_id"])
          order.try(:agent_id)
        end
      ]
    end.each do |commentable, params_items_per_agent_id|
      next if commentable.blank?
      params_items_per_agent_id.each do |agent_id, params_items|
        next if agent_id.blank?
        sleep(1)
        CommentMailer.target_agent(commentable.class.name, commentable.id, agent_id, params_items).deliver_now
      end
    end
  end
end
