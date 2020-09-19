class Campaign < ApplicationRecord
  include Statementable
  include Likable
  extend Enumerize

  TEMPLATES = %w( basic petition photo order map sympathy )
  TEMPLATES_SPECIAL = %w( special_map_with_assembly special_any_speech special_speech order_assembly )

  LARGE_AREA = %w(서울특별시 부산광역시 대구광역시 인천광역시 광주광역시 대전광역시 울산광역시 세종특별자치시 경기도 경기남부 경기북부 강원도 충청북도 충청남도 전라북도 전라남도 경상북도 경상남도 제주특별자치도)
  CONGRESSMEN = [
    ['강길부', '울산', '울주군', '울산광역시 울주군 범서읍 굴화리 32-2번지 인재빌딩3층'],
    ['강석진', '경남', '산청군함양군거창군합천군',  '경상남도 거창군 거창읍 시장2길 9 애지안 2층'],
    ['강석호', '경북', '영양군영덕군봉화군울진군',  '경상북도 영덕군 영덕읍 중앙길 99번지'],
    ['강효상', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['경대수', '충북', '증평군진천군음성군', '충청북도 음성군 음성읍 음성천동길 160 2층'],
    ['곽대훈', '대구', '달서구갑',  '대구광역시 달서구 달구벌대로 1521 K타워 8층'],
    ['곽상도', '대구', '중구남구',  '대구광역시 남구 중앙대로 242 명종빌딩 4층'],
    ['권석창', '충북', '제천시단양군',  '충청북도 제천시 의병대로78 (명동로터리 이동우컬렉션2층)'],
    ['권성동', '강원', '강릉시', '강원도 강릉시 교동광장로 90 FCC빌딩 4층'],
    ['김광림', '경북', '안동시', '경상북도 안동시 당북동 48-3 선메디컬빌딩'],
    ['김규환', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['김기선', '강원', '원주시갑',  '강원도 원주시 서원대로 113 6층'],
    ['김도읍', '부산', '북구강서구을',  '부산광역시 강서구 대저1동 2377-4번지'],
    ['김명연', '경기', '안산시단원구갑', '경기도 안산시 단원구 삼일로 310 서울프라자 4층'],
    ['김무성', '부산', '중구영도구', '부산광역시 영도구 태종로 40'],
    ['김상훈', '대구', '서구',  '대구광역시 서구 평리4동 1371-8 경총회관 3층'],
    ['김석기', '경북', '경주시', '경상북도 경주시 금성로 308 2층 (서부동)'],
    ['김선동', '서울', '도봉구을',  '서울시 도봉구 방학1동 680-1 이정빌딩 3F'],
    ['김성원', '경기', '동두천시연천군', '경기도 동두천시 평화로 2248 봉익빌딩 2층'],
    ['김성찬', '경남', '창원시진해구',  '경상남도 창원시 진해구 충장로347 NH농협2층'],
    ['김성태', '서울', '강서구을',  '서울시 강서구 양천로 112 선샤인빌딩 3층'],
    ['김성태', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['김세연', '부산', '금정구', '부산 금정구 중앙대로 1711 금정빌딩 2층'],
    ['김순례', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['김승희', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['김영우', '경기', '포천시가평군',  '경기도 포천시 구절초로 12 3층'],
    ['김재경', '경남', '진주시을',  '경상남도 진주시 동진로 146 대광빌딩 4층'],
    ['김정재', '경북', '포항시북구', '경상북도 포항시 북구 새천년대로 1210 이레빌딩 3층'],
    ['김정훈', '부산', '남구갑', '부산광역시 남구 못골로 104 3층'],
    ['김종석', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['김종태', '경북', '상주시군위군의성군청송군',  '경상북도 상주시 서성동 56-6 동영빌딩 3층'],
    ['김진태', '강원', '춘천시', '강원도 춘천시 후석로 10 청인빌딩 4층'],
    ['김태흠', '충남', '보령시서천군',  '충남 보령시 동대동 1833번지 대응빌딩 4층'],
    ['김학용', '경기', '안성시', '경기도 안성시 중앙로 473'],
    ['김한표', '경남', '거제시', '경상남도 거제시 서문로 56 명성빌딩 4층'],
    ['김현아', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['나경원', '서울', '동작구을',  '서울시 동작구 사당로 219 메트로빌딩 4층'],
    ['문진국', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['민경욱', '인천', '연수구을',  '인천광역시 연수구 컨벤시아대로 55 송도이안 2층 202호'],
    ['박대출', '경남', '진주시갑',  '경상남도 진주시 진주성로 20,  2층 '],
    ['박덕흠', '충북', '보은군옥천군영동군괴산군',  '충청북도 옥천군 옥천읍 중앙로 10'],
    ['박맹우', '울산', '남구을', '울산광역시 남구 번영로 90-1 항사랑병원 4층'],
    ['박명재', '경북', '포항시남구울릉군',  '경상북도 남구 포스코대로 393 홍제빌딩 5층'],
    ['박성중', '서울', '서초구을',  '서울특별시 강남대로 221 양재주차빌딩 515호'],
    ['박순자', '경기', '안산시단원구을', '경기도 안산시 단원구 고잔동 706-3 장은타워 511호'],
    ['박완수', '경남', '창원시의창구',  '경상남도 창원시 의창구 태복산로317 오션파이브빌딩 201호'],
    ['박인숙', '서울', '송파구갑',  '충청남도 천안시 동남구 만남로 6 캐럿21 7층'],
    ['박찬우', '충남', '천안시갑',  '충남 천안시 동남구 충절로 174 (원성동 제일빌딩 5층)'],
    ['배덕광', '부산', '해운대구을', '부산광역시 해운대구 반여로 41번길 54 대우빌딩 4층'],
    ['백승주', '경북', '구미시갑',  '경북 구미시 구미대로 342'],
    ['서청원', '경기', '화성시갑',  '경기도 화성시 향남읍 삼천병마로 194 2층 '],
    ['성일종', '충남', '서산시태안군',  '충남 서산시 고운로 147, 3층'],
    ['송석준', '경기', '이천시', '경기도 이천시 중리천로72번길 2층(산림조합건물)'],
    ['송희경', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['신보라', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['신상진', '경기', '성남시중원구',  '경기도 성남시 중원구 산성대로 326-2(중앙동 352) 수경빌딩 5층'],
    ['심재철', '경기', '안양시동안구을', '경기도 안양시 동안구 경수대로 540 성옥빌딩 1층(호계1동)'],
    ['안상수', '인천', '중구동구강화군옹진군',  '인천시 강화군강화읍 강화대로 401-1 향군회관 2층'],
    ['엄용수', '경남', '밀양시의령군함안군창녕군',  '경남 밀양시 밀양대로 1856'],
    ['여상규', '경남', '사천시남해군하동군', '경상남도 사천시 용현면 덕곡리 514-3 부성빌딩 202호 (664-952)'],
    ['염동열', '강원', '태백시횡성군영월군평창군정선군', '강원도 영월군 영월읍 중앙로 56'],
    ['오신환', '서울', '관악구을',  '서울시 관악구 남부순환로 1469, 3층'],
    ['원유철', '경기', '평택시갑',  '경기도 평택시 지산로60 3층 (지산동)'],
    ['유기준', '부산', '서구동구',  '부산광역시 서구 자갈치로1 신진빌딩 4층'],
    ['유민봉', '비례대표', '비례',  '서울특별시 영등포구 의사당대로1 국회의원회관 1015호'],
    ['유승민', '대구', '동구을', '대구시 동구 화랑로 459 테바빌딩 3층 (41166)'],
    ['유의동', '경기', '평택시을',  '경기도 평택시 합정동 965-13 명성빌딩 5층'],
    ['유재중', '부산', '수영구', '부산광역시 수영구 수영로 672 동광빌딩 4층(48267)'],
    ['윤상직', '부산', '기장군', '부산광역시 기장군 기장읍 기장대로 516 자이안트빌딩 305호'],
    ['윤상현', '인천', '남구을', '인천광역시 남구 소성로 171'],
    ['윤영석', '경남', '양산시갑',  '경상남도 양산시 삼일로 70(중부동 402) 구,터미널 건물 1층'],
    ['윤재옥', '대구', '달서구을',  '대구광역시 달서구 월배로202(상인동,남정빌딩) 6층'],
    ['윤종필', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['윤한홍', '경남', '창원시마산회원구',  '경상남도 창원시 마산회원구 율림교로 13 메트로M빌딩 504호'],
    ['이군현', '경남', '통영시고성군',  '경상남도 통영시 북신동 1-2 농협축협건물 3층(통영)'],
    ['이만희', '경북', '영천시청도군',  '경상북도 영천시 완산로 6길(완산동 1000-70) 3층'],
    ['이명수', '충남', '아산시갑',  '충청남도 아산시 온천대로 1541 명지빌딩 5층'],
    ['이양수', '강원', '속초시고성군양양군', '속초시 동해대로 4213 복오빌딩 3층'],
    ['이완영', '경북', '고령군성주군칠곡군', '경상북도 칠곡군 왜관읍 중앙로 147 삼양빌딩 3층'],
    ['이우현', '경기', '용인시갑',  '경기도 용인시 처인구 중부대로 1403 태중빌딩 501호'],
    ['이은권', '대전', '중구',  '대전광역시 중구 계백로 1528 (유천동) 남강빌딩 3층'],
    ['이은재', '서울', '강남구병',  '서울특별시 강남구  삼성로 349 우진빌딩 403호'],
    ['이장우', '대전', '동구',  '대전광역시 동구 대전로 887 화성빌딩 5층'],
    ['이정현', '전남', '순천시', '전라남도 순천시 비봉2길 4-38 3층(조례동) 이정현의원사랑방'],
    ['이종구', '서울', '강남구갑',  '서울특별시 강남구 논현로 667 진우빌딩 401호'],
    ['이종명', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['이종배', '충북', '충주시', '충청북도 충주시 중앙로 3(문화동 569-1) '],
    ['이주영', '경남', '창원시마산합포구',  '경상남도 창원시 마산합포구 해안대로 297 (신포동 1가)준빌딩 3층'],
    ['이진복', '부산', '동래구', '부산광역시 동래구 동래로 136번길 32, 3층'],
    ['이채익', '울산', '남구갑', '울산광역시 남구 수암로 4 템포빌딩 10층 (680-831)'],
    ['이철규', '강원', '동해시삼척시',  '강원도 동해시 천곡동 흥국생명빌딩 3층'],
    ['이철우', '경북', '김천시', '경상북도 김천시 신음동 424-1 5층'],
    ['이학재', '인천', '서구갑', '인천광역시 서구 가정로 369 (신현동, 서경백화점 3층)'],
    ['이헌승', '부산', '부산진구을', '부산광역시 부산진구 가야대로 607 새마을회관 8층'],
    ['이현재', '경기', '하남시', '경기도 하남시 하남대로 800 해림빌딩 2층'],
    ['이혜훈', '서울', '서초구갑',  '서울시 서초구 신반포로 219 반포쇼핑타운 8동 410호'],
    ['임이자', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['장석춘', '경북', '구미시을',  '경상북도 구미시 인동가산로 33 쌍둥이빌딩 9층'],
    ['장제원', '부산', '사상구', '부산광역시 사상구 사상로 181'],
    ['전희경', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['정갑윤', '울산', '중구',  '울산광역시 중구번영로 355 (학산동) 중원빌딩 4층'],
    ['정병국', '경기', '여주시양평군',  '경기도 여주시 여흥로 111 2층/ 양평군 양평읍 시민로 117 2층'],
    ['정양석', '서울', '강북구갑',  '서울특별시 강북구 노해로 88'],
    ['정용기', '대전', '대덕구', '대전광역시 대덕구 한밭대로 990 3층 (오정동 69-3)'],
    ['정우택', '충북', '청주시상당구',  '충북 청주시 상당구 청남로 2200'],
    ['정운천', '전북', '전주시을',  '전라북도 전주시 완산구 홍산로 275 충광빌딩 503호'],
    ['정유섭', '인천', '부평구갑',  '인천광역시 부평구 주부토로 3'],
    ['정종섭', '대구', '동구갑', '대구광역시 동구 동대구로 523'],
    ['정진석', '충남', '공주시부여군청양군', '충남 공주시 번영1로 70 범아빌딩 3층'],
    ['정태옥', '대구', '북구갑', '대구 북구 동북로 156 스카이빌딩 7층'],
    ['조경태', '부산', '사하구을',  '부산광역시 사하구 장림2동 416-1번지'],
    ['조원진', '대구', '달서구병',  '대구광역시 달수구 와룡로 124'],
    ['조훈현', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['주광덕', '경기', '남양주시병', '경기도 남양주시 경춘로 382번지'],
    ['주호영', '대구', '수성구을',  '대구광역시 수성구 동대구로 6'],
    ['지상욱', '서울', '중구성동구을',  '서울특별시 중구 다산로 124 (신당동) 2층'],
    ['최경환', '경북', '경산시', '경상북도 경산시 중앙로 38 2층'],
    ['최교일', '경북', '영주시문경시예천군', '경상북도 영주시 대동로144 2층'],
    ['최연혜', '비례대표', '비례',  '서울시 영등포구 의사당대로 1'],
    ['추경호', '대구', '달성군', '대구광역시 달성군 화원읍 성화로9 (화원빌딩 5층)'],
    ['하태경', '부산', '해운대구갑', '부산시 해운대구 좌동 1479-1 웅신시네아트 209호'],
    ['한선교', '경기', '용인시병',  '경기도 용인시 수지구 포은대로 410'],
    ['함진규', '경기', '시흥시갑',  '경기도 시흥시 복지로 3 (유암타워), 501호'],
    ['홍문종', '경기', '의정부시을', '경기도 의정부시 신곡동 762-2 엘리트타운 601호'],
    ['홍문표', '충남', '홍성군예산군',  '충남 홍성군 홍성읍 홍성천길 150 3층 / 충남 홍성군 홍성읍 오관리 464-13'],
    ['홍일표', '인천', '남구갑', '인천시 남구 주안1동 190-5번지 인혜빌딩 502호'],
    ['홍철호', '경기', '김포시을',  '경기도 김포시 김포한강1로 247 해리움타운 508호'],
    ['황영철', '강원', '홍천군철원군화천군양구군인제군', '강원도 홍천군 홍천읍 진삼거리길 13 한샘빌딩 3층 후원회사무실']
  ]

  enumerize :use_signer_email, in: [:unused, :required, :optional], default: :unused
  enumerize :use_signer_address, in: [:unused, :required, :optional], default: :unused
  enumerize :use_signer_phone, in: [:unused, :required, :optional], default: :unused
  enumerize :use_signer_country, in: [:unused, :required, :optional], default: :unused
  enumerize :use_signer_city, in: [:unused, :required, :optional], default: :unused

  acts_as_tagger

  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :orders, through: :comments
  has_many :signs, dependent: :destroy
  has_many :signed_users, through: :signs, source: :campaign
  belongs_to :area, optional: true
  belongs_to :issue, optional: true
  has_many :speeches, dependent: :destroy
  has_many :issue_mailings, dependent: :destroy, as: :source
  has_many :email_subscriptions, as: :mailerable
  has_many :signer_emails, dependent: :destroy
  has_one :organization, through: :project
  has_many :stories, dependent: :destroy, as: :storiable

  mount_uploader :cover_image, ImageUploader
  mount_uploader :social_image, ImageUploader

  validates :goal_count, :numericality => { :greater_than_or_equal_to => 0 }

  scope :popular, -> { where("views_count > 2000").order('created_at DESC') }
  scope :recent, -> { order('created_at DESC') }
  scope :by_organization, ->(organization) { where(project: organization.projects) }
  scoped_search on: [:title]
  scope :published, -> { where('opened_at <= ?', DateTime.now).where.not(stealthily: true) }

  before_save :default_opened_at
  before_save :setup_api_secure_key
  after_save :mailing_issue,  if: proc { issue_id_changed? }

  def signed? someone
    someone.present? and signs.exists?(user: someone)
  end

  def has_goal?
    goal_count.present? && goal_count > 0
  end

  def goalable?
    !%w( sympathy special_map_with_assembly special_any_speech special_speech ).include?(self.template)
  end

  def success?
    return false unless has_goal?
    percentage >= 100
  end

  def percentage
    if has_goal?
      if picketable?
        (comments_count.fdiv(goal_count) * 100).to_i
      else
        (signs_count.fdiv(goal_count) * 100).to_i
      end
    else
      100
    end
  end

  def success_order?
    return false unless has_goal?
    percentage_order >= 100
  end

  def percentage_order
    has_goal? ? ( order_users_count.to_f / goal_count * 100 ).to_i : 100
  end

  def has_cover_image?
    cover_image.file.present?
  end

  def fallback_social_image_url
    if self.read_attribute(:social_image).present?
      self.social_image_url
    elsif self.project.try(:read_attribute, :social_image).present?
      self.project.social_image_url
    else
      self.cover_image_url
    end
  end

  def formatted_title_to_agent(user_nickname = nil)
    "캠페인 \"#{self.title_to_agent.presence || self.title}\"에 대해 #{"#{user_nickname}님 등이 " if user_nickname.present?}행동을 촉구합니다"
  end

  def closed?
    self.closed_at.present?
  end

  def opened?
    return false if self.opened_at.blank? or self.opened_at > DateTime.now
    !closed?
  end

  def comment_closed?
    if %w(petition order_assembly).include?(self.template)
      !self.comment_enabled
    else
      closed?
    end
  end

  def comment_opened?
    !comment_closed?
  end

  def signable?
    self.template == 'petition'
  end

  def orderable?
    %(order order_assembly).include? self.template
  end

  def picketable?
    %(basic photo map).include? self.template
  end

  def mailing_issue
    self.issue_mailings.where(action: 'add').where(deleted_at: nil).update_all(deleted_at: DateTime.now)
    self.issue_mailings.find_or_create_by(issue: self.issue, action: 'add')
  end

  def order_users_count
    return @__order_users_count if @__order_users_count.present?
    @__order_users_count = self.comments.joins(:orders).select(:commenter_name, :commenter_email).distinct.size
    @__order_users_count
  end

  def pickets_count
    picketable? ? comments_count : 0
  end

  def highlight_ordered_comments(limit)
    result = []
    Comment.where(id: Order.where(comment: self.comments).select(:comment_id)).recent.limit(100).each do |comment|
      next if result.any?{ |item|
        item.user_nickname == comment.user_nickname
      }
      result << comment
      return result if result.length > limit
    end
    result
  end

  def stancable?
    need_stance
  end

  def opened_at_to_human
    return I18n.t('views.campaign.unknown_opened_at') if self.opened_at.blank? or self.opened_at > DateTime.now

    opened_at
  end

  def has_confirm_third_party?
    self.confirm_third_party.present?
  end

  def is_valid_template(template)
    return false if template.blank?
    (TEMPLATES + TEMPLATES_SPECIAL).include? template
  end

  private

  def default_opened_at
    if self.opened_at.blank?
      self.opened_at = Date.today
    end
  end

  def setup_api_secure_key
    self.api_secure_key ||= SecureRandom.base64(30)
  end
end
