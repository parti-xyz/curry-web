class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :recoverable,
         :omniauthable,
         :omniauth_providers => [:facebook, :twitter]
        #  :authentication_keys => {term_privacy: true, term_service: true}

  # assiciations
  has_many :following_issues, dependent: :destroy
  has_many :articles, dependent: :nullify
  has_many :people, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :races, dependent: :destroy
  has_many :thumbs, dependent: :destroy
  has_many :speeches, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :projects, dependent: :restrict_with_exception
  has_many :participated_projects, through: :participations, source: :project
  has_many :archives, dependent: :restrict_with_exception
  has_many :bulk_tasks, dependent: :destroy
  has_many :organizers, dependent: :destroy
  has_many :campaigns, dependent: :restrict_with_exception
  has_many :agenda_documents, dependent: :nullify
  has_many :agendas, dependent: :nullify
  has_many :archive_documents, dependent: :restrict_with_error
  has_many :comments, dependent: :destroy
  has_many :deprecated_events, dependent: :nullify
  has_many :discussions, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :memorials, dependent: :restrict_with_exception
  has_many :notes, dependent: :destroy
  has_many :organizations, dependent: :restrict_with_exception
  has_many :organizers, dependent: :restrict_with_exception
  has_many :participations, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :races, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :sent_requests, dependent: :destroy
  has_many :signs, dependent: :destroy
  has_many :speeches, dependent: :destroy
  has_many :statements, dependent: :nullify, foreign_key: :last_updated_user_id
  has_many :stories, dependent: :restrict_with_exception
  has_many :surveys, dependent: :restrict_with_exception
  has_many :polls, dependent: :restrict_with_exception
  has_many :sympathies, dependent: :restrict_with_exception
  has_many :timeline_documents, dependent: :restrict_with_exception
  has_many :timelines, dependent: :restrict_with_exception
  has_many :wiki_revisions, dependent: :restrict_with_exception
  has_many :wikis, dependent: :restrict_with_exception
  has_many :thumbs, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :signer_emails, dependent: :nullify

  # validations
  VALID_NICKNAME_REGEX = /\A[ㄱ-ㅎ가-힣a-z0-9_]+\z/i

  validates :nickname,
    presence: true,
    exclusion: { in: %w(app new edit index session login logout users organizer admin all crew issue group project) },
    format: { with: VALID_NICKNAME_REGEX, message: :need_nickname_format },
    uniqueness: { case_sensitive: false },
    length: { maximum: 20 }
  validate :nickname_exclude_pattern
  validates :email,
    presence: true,
    format: { with: Devise.email_regexp },
    uniqueness: {scope: [:provider]}
  validates :uid, uniqueness: {scope: [:provider]}
  validates :password,
    presence: true,
    confirmation: true,
    length: Devise.password_length,
    if: proc { password_required? }
  validates_confirmation_of :password, if: proc { password_required? }
  validates :term_service, :presence => true
  validates :term_privacy, :presence => true
  validates :term_privacy_must, :presence => true
  # filters
  before_save :downcase_nickname
  before_validation :strip_whitespace_nickname, only: :nickname
  before_save :set_uid

  # mount
  mount_uploader :image, UserImageUploader

  # scope
  default_scope { order('id DESC') }
  scope :not_someone, ->(someone) { where.not(id: someone.id) }

  INTERVAL_ISSUE_MAILING = 7.days.ago

  scope :need_to_delivery_issues_summary_mailing, -> {
    where("issues_summary_email_sent_at <= ?", User::INTERVAL_ISSUE_MAILING)
    .or(self.where(issues_summary_email_sent_at: nil))
    .where(enable_mailing: true)
    .order(:issues_summary_email_sent_at)
  }

  # methods for devises/auth
  def self.parse_omniauth(data)
    {provider: data['provider'], uid: data['uid'], email: data['info']['email'], image: data['info']['image']}
  end

  def self.new_with_session(params, session)
    resource = super
    auth = session["devise.omniauth_data"]
    if auth.present?
      auth["email"] = params['email'] if params['email'].present?
      resource.assign_attributes(auth)
      resource.password = Devise.friendly_token[0,20]
      resource.confirmed_at = DateTime.now
      resource.remote_image_url = auth['image']
    else
      resource.provider = 'email'
    end
    resource
  end

  def self.find_for_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first
  end

  # the other methods

  def following?(issue)
    following_issues.exists?(issue: issue)
  end

  # email auth

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions.to_h).where(["provider = 'email' AND uid = :value", { :value => email.downcase }]).first
  end

  # for recovering the password for an account
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    unless conditions.has_key?(:confirmation_token)
      conditions.merge! provider: 'email'
    end
    where(conditions.to_h).first
  end

  def is_admin?
    has_role?(:admin)
  end

  def issues_summary_mailing_delivered!
    self.touch(:issues_summary_email_sent_at)
  end

  def datetime_of_need_to_issues_summary_mailing
    [User::INTERVAL_ISSUE_MAILING.to_date.yesterday, self.issues_summary_email_sent_at].compact.max.at_beginning_of_day
  end

  def has_image?
    self.read_attribute(:image).present?
  end

  def has_agreed_terms?
    return self.term_privacy.present? && self.term_service.present? && self.term_privacy_must.present?
  end

  def banned?
    self.banned_at.present?
  end

  private

  def set_uid
    self.uid = self.email if self.provider == 'email'
  end

  def downcase_nickname
    self.nickname = nickname.downcase
  end

  def nickname_exclude_pattern
    if (self.nickname =~ /\Aparti.*\z/i) and (self.nickname_was !~ /\Aparti.*\z/i)
      errors.add(:nickname, I18n.t('errors.messages.taken'))
    end
  end

  def strip_whitespace_nickname
    self.nickname = self.nickname.strip unless self.nickname.nil?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
