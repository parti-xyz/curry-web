class Project < ApplicationRecord
  include Organizable
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  belongs_to :user
  belongs_to :organization, optional: true
  belongs_to :project_category, optional: true
  has_many :stories, dependent: :destroy, as: :storiable
  has_many :discussions, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :wikis, dependent: :destroy
  has_many :surveys, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :discussion_categories, dependent: :destroy

  has_many :deprecated_events, dependent: :destroy

  mount_uploader :image, ImageUploader
  mount_uploader :social_image, ImageUploader

  scope :recent, -> { order('id DESC') }

  validates :slug, format: { with: /\A[a-z0-9\-_]+\z/i }, uniqueness: true
  validates :user, presence: true

  after_create :fallback_slug

  attr_accessor :user_nickname

  def component_title(modle_name)
    model = modle_name.classify.safe_constantize
    name_by_model = model.blank? ? I18n.t("activerecord.models.#{modle_name}") : model.model_name.human
    send(:"#{modle_name}_title").blank? ? name_by_model : send(:"#{modle_name}_title")
  end

  def poll_and_survey_title
    poll_title
  end

  def participated? someone
    participations.exists? user: someone
  end

  def polls_and_surveys_recent
    [polls + surveys].flatten.sort_by(&:created_at).reverse
  end

  DEFAULT_SORTED_COMPONENT_NAMES = %i(wiki discussion poll campaign story townhall)
  def component_sequence(component_name)
    attr = :"#{component_name}_sequence"
    ((try(attr) || 0) * 10) + DEFAULT_SORTED_COMPONENT_NAMES.index(component_name.to_sym)
  end

  def component_names_sorted
    DEFAULT_SORTED_COMPONENT_NAMES.sort_by { |component_name| component_sequence(component_name) }
  end

  def fallback_social_image_url
    if self.read_attribute(:social_image).present?
      self.social_image_url
    else
      self.image_url
    end
  end

  def action_count
    campaigns.count + polls.count + surveys.count + wikis.count + discussions.count
  end

  def metoo_count
    action_count +
    campaigns.sum(:signs_count) + polls.sum(:votes_count) + surveys.sum(:feedbacks_count)
  end

  def views_count
    campaigns.sum(:views_count) + polls.sum(:views_count) + surveys.sum(:views_count) +
    wikis.sum(:views_count) + discussions.sum(:views_count) +
    stories.sum(:views_count)
  end

  private

  def fallback_slug
    if self.slug.blank?
      update_columns(slug: self.id)
    end
  end

end
