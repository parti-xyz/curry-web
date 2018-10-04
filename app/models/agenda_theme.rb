class AgendaTheme < ApplicationRecord
  has_and_belongs_to_many :agendas, uniq: true
  has_many :issues, dependent: :nullify
  has_many :options, through: :issues
  mount_uploader :cover, ImageUploader

  def agent_positions
    {
      '2017-president' => Position.named('19대_대선후보'),
      'votefuture' => Position.named('19대_대선후보'),
    }.fetch(slug, nil)
  end
end
