class CommentOrderJob
  include Sidekiq::Worker

  if Rails.env.production? or Rails.env.staging?
    sidekiq_options batch_flush_size: 30,
      batch_flush_interval: 60 * 5,
      retry: 5
  end

  def perform(grouping_param)
    grouping_param = if grouping_param.is_a?(Array)
      grouping_param.flatten
    else
      [grouping_param]
    end

    Sidekiq.logger.error("grouping_params.inspect: #{grouping_param.inspect}")

    grouping_param.map do |comment_id|
      Comment.find_by(id: comment_id)
    end.group_by do |comment|
      comment.try(:commentable)
    end.each do |commentable, comments|
      next if commentable.blank?

      Order.where(comment_id: comments).to_a.group_by do |order|
        order&.agent_id
      end.each do |agent_id, orders|
        next if agent_id.blank?
        sleep(1)

        statement = commentable.statements.find_or_create_by(agent_id: agent_id)
        statement_key = statement.statement_keys.last
        unless statement_key.reusable?
          statement_key = statement.statement_keys.build(key: SecureRandom.hex(50))
          statement_key.save
        end

        params = orders.map do |order|
          {
            'comment_id' => order.comment_id,
            'order_id' => order.id,
            'statement_key_id' => statement_key.id
          }
        end
        CommentMailer.target_agent(commentable.class.name, commentable.id, agent_id, params).deliver_now
      end

      Comment.where(id: comments).update_all(mailing: :sent)
    end
  end
end
