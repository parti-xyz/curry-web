class Issue < ApplicationRecord
  has_and_belongs_to_many :agendas
  belongs_to :agenda_theme, optional: true
  has_many :opinions, dependent: :destroy
  has_many :following_issues, dependent: :destroy
  has_many :followers, -> { order 'following_issues.created_at desc' }, through: :following_issues, source: :user
  has_many :comments, as: :commentable
  has_many :agents, -> { reorder('').distinct }, through: :opinions
  has_many :campaigns, dependent: :nullify

  acts_as_taggable

  mount_uploader :image, ImageUploader

  validates :title, uniqueness: true, presence: true

  after_initialize :trim_title

  default_scope { order('title ASC') }
  scope :with_theme, ->(theme) { where('agenda_theme_id': theme.id) }
  scoped_search on: [:title]

  def categorized_agents(position_name, quote)
    if quote.present?
      opinions = self.opinions.recent.of_quote(quote).of_agent(agents.of_position_names(position_name))
      opinions.map &:agent
    else
      Agent.of_position_names(position_name).where.not(id: self.agents)
    end
  end

  def has_any_stances?(agents = nil)
    return false unless has_stance?

    result = self.opinions.where.not(stance: nil)
    result = result.where(agent_id: agents) unless agents.nil?

    result.exists?
  end

  def theme_name
    agenda_theme.try(:title)
  end

  def following?(someone)
    followers.exists?(id: someone)
  end

  def following_of(someone)
    following_issues.find_by(user_id: someone)
  end

  def self.group_by_theme issues
    issues.to_a.group_by{ |i| i.agenda_theme }.sort_by { |k,v| k.try(:name) }
  end

  private

  def trim_title
    self.title.try(:strip!)
  end
end
