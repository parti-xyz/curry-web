class AgentMailer < ApplicationMailer
  def refresh_access_token(agent_id)
    @agent = Agent.find_by(id: agent_id)
    return if @agent.blank? or @agent.refresh_access_token.blank?

    mail(to: @agent.email, subject: '[빠띠 캠페인즈] 비밀번호 재설정',
      template_name: "refresh_access_token")
  end
end
