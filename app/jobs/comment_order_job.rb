class CommentOrderJob
  include Sidekiq::Worker
  sidekiq_options lock: :while_executing, lock_timeout: 0, on_conflict: :raise, retry: 8

  def perform
    ready_comments = Comment.where(mailing: :ready).after(1.weeks.ago)
    ready_comments.select(:commentable_id, :commentable_type).distinct.each do |row|
      commentable_model = row.commentable_type&.classify&.safe_constantize
      next if commentable_model.blank?
      commentable = commentable_model.find_by(id: row.commentable_id)
      next if commentable.blank?

      current_ready_comments = ready_comments.where(commentable: commentable)
      next if current_ready_comments.empty?

      first_ready_comment = current_ready_comments.order(:created_at).first
      next if first_ready_comment.created_at > 2.hours.ago && current_ready_comments.count < 100

      current_ready_comments.find_in_batches do |comments_group|

        Order.where(comment_id: comments_group).to_a.group_by do |order|
          order&.agent_id
        end.each do |agent_id, orders|
          next if agent_id.blank?
          agent = Agent.find_by(id: agent_id)
          next if agent.blank? || agent.email.blank?

          sleep(1)

          statement = commentable.statements.find_or_create_by(agent_id: agent_id)
          statement_key = statement.statement_keys.last
          if statement_key.blank? || !statement_key.reusable?
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

        Comment.where(id: comments_group).update_all(mailing: :sent)
      end
    end
  end
end
