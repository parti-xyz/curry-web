class Agenda < ApplicationRecord
  include Likable

  belongs_to :user, optional: true
  has_and_belongs_to_many :issues
  has_many :opinions, through: :issues
  has_many :agents, -> { reorder('').distinct }, through: :opinions
  has_many :agenda_documents, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :agenda_themes, uniq: true

  acts_as_taggable

  mount_uploader :image, ImageUploader

  scope :sort_by_name, -> { order("if(ascii(substring(name, 1)) < 128, 1, 0)").order(:name) }

  def opinions_by agent
    opinions.where(agent: agent)
  end

  def hot?(theme = nil)
    if theme.present?
      Opinion.where(issue_id: issues.with_theme(theme)).sum(:votes_count) > 1000
    else
      Opinion.where(issue_id: issues).sum(:votes_count) > 1000
    end
  end
end
