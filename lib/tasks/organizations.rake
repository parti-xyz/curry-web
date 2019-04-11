namespace :organizations do
  desc "seed group"
  task 'seed' => :environment do
    Organization.transaction do
      seed(site_name: '우리가 주인이당! Would You Party?',
        title: '우주당',
        description: '직접 민주주의 프로젝트 정당 우주당입니다. 우리가 주인이 되어 우리의 이야기로 정치하는, 새롭고 즐거운 시도들을 함께 해요!',
        slug: 'wouldyouparty',
        slogan: '우리가 주인이 되는 직접 민주주의 프로젝트 정당',
        community_url: 'https://wouldyou.parti.xyz/')

      seed(title: '우리가 만드는 나라',
        description: '',
        slug: 'urimanna',
        slogan: '일상 속에서의 민주주의 실현',
        community_url: 'https://kdemo.parti.xyz/')

      seed(title: '바꿈',
        description: '',
        slug: 'change2020',
        slogan: '세상을 바꾸는 꿈',
        community_url: 'https://change.parti.xyz/')

      seed(site_name: '전교조',
        title: '전교조',
        description: '교육의 자주성, 전문성 확립과 교육민주화 실현을 위한 전국의 유치원, 초등학교, 중·고등학교 교사들의 자주적 노동조합입니다',
        slug: 'eduhope',
        slogan: '교육과 세상을 바꾸는 전교조',
        community_url: 'https://eduhope.parti.xyz/')

      seed(site_name: '여성폭력 인식개선',
        title: '여성폭력 인식개선',
        description: '여성에 대한 폭력을 멈추기 위해',
        slug: 'vaw',
        slogan: '여성에 대한 폭력을 멈추기 위해')

      seed(site_name: '국민개헌넷',
        title: '국민개헌넷',
        description: '국민주도 헌법개정 전국 네트워크',
        slug: 'rebootkorea',
        single_project_slug: 'rebootkorea',
        slogan: '국민주도 헌법개정 전국 네트워크')

      seed(site_name: '차별잇수다',
        title: '차별잇수다',
        description: '차별잇수다',
        slug: 'sooda',
        slogan: '차별에 맞서는 용기를 잇는 수다')

    end
  end

  def seed(options)
    slug = options[:slug]
    organization = Organization.find_or_initialize_by slug: slug
    organization.assign_attributes(options)
    organization.save!
  end

  def category_seed(organization_slug, options)
    slug = options[:slug]
    organization = Organization.find_by(slug: organization_slug)
    category = ProjectCategory.find_or_initialize_by slug: slug
    category.assign_attributes(options)
    category.organization = organization
    category.save!
  end
end
