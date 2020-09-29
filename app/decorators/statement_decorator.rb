module StatementDecorator
  UNSURE_STANCE_TEXT_HUMAN = '무응답'

  def stance_code
    if self.stancable?
      self.sure? ? self.stance : 'unsure'
    else
      self.body.present? ? 'sure' : 'unsure'
    end
  end

  def stance_text_human
    if self.stancable?
      if stance_code == 'unsure'
        if self.body.present?
          '보류'
        else
          '무응답'
        end
      else
        self.stance.text
      end
    else
      stance_code == 'sure' ? '응답' : '무응답'
    end
  end
end