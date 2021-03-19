class CommentMailer < ApplicationMailer
  def target_agent(commentable_type, commentable_id, agent_id, params_items, use_sample = false)
    # comment_id, order_id, statement_key_id
    @commentable = commentable_type.classify.safe_constantize.try(:find_by, {id: commentable_id})
    return if @commentable.blank?

    @comments = []
    @orders = []
    @statement_key = nil
    params_items.each do |params|
      comment = Comment.find_by(id: params['comment_id'])
      next if comment.blank?
      statement_key = StatementKey.find_by(id: params['statement_key_id'])
      next if statement_key.blank?
      @statement_key = statement_key
      order = Order.find_by(id: params['order_id'])
      next if order.blank?

      @comments << comment
      @orders << order
    end

    @agent = Agent.find_by(id: agent_id)
    return if @agent.blank? || @agent.email.blank?

    template_name = "target_agent_#{@commentable.class.name.underscore}"
    if @commentable.respond_to? :template
      special_template_name = "target_agent_#{@commentable.class.name.underscore}_#{@commentable.template}"
      if lookup_context.exists?("comment_mailer/#{special_template_name}")
        template_name = special_template_name
      end
    end

    headers['X-PARTI-ORDERS'] = @orders.map(&:id).to_json

    campainer_email = @commentable.try(:sample_email).presence if use_sample

    mail(
      to: @agent.email,
      bcc: campainer_email,
      template_name: template_name)

    @commentable.update_columns(last_sample_at: DateTime.now) if use_sample
  end
end
