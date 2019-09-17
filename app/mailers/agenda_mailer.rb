class AgendaMailer < ApplicationMailer
  def push(sender, recipient_name, recipient_email, agenda_id, title, body)
    @agenda = Agenda.find_by id: agenda_id
    return if [@agenda, sender, recipient_name, recipient_email, title, body].any? &:blank?
    @title = title
    @body = body
    @sender = sender
    @recipient_name = recipient_name
    mail(to: recipient_email,
      subject: title)
  end

  def note(note_id)
    @note = Note.find_by(id: note_id)
    return if @note.blank?

    @opinion = @note.opinion
    @agent = @opinion.agent
    return if @agent.email.blank?


    mail(to: @agent.email,
      subject: "[빠띠 캠페인즈] 귀하의 '#{@opinion.issue.try(:title)}'에 대한 입장에 대해 #{@note.user_nickname}님이 의견을 보냅니다.")
  end
end
