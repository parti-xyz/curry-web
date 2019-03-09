class CommentMailer < ApplicationMailer
  def target_agent(comment_id, order_id, statement_key_id)
    @comment = Comment.find_by(id: comment_id)
    return if @comment.blank?

    @statement_key = StatementKey.find_by(id: statement_key_id)
    return if @statement_key.blank?

    @order = Order.find_by(id: order_id)
    return if @order.blank?

    @agent = @order.agent

    unless @agent.try(:email).try(:present?)
      @comment.update_attributes(mailing: :fails)
      return
    end
    @comment.update_attributes(mailing: :sent)

    template_name = "target_agent_#{@comment.commentable.class.name.underscore}"
    if @comment.commentable.respond_to? :template
      special_template_name = "target_agent_#{@comment.commentable.class.name.underscore}_#{@comment.commentable.template}"
      if lookup_context.exists?("comment_mailer/#{special_template_name}")
        template_name = special_template_name
      end
    end

    mail(to: @agent.email,
      template_name: template_name)
  end
end
