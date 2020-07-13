include ActionView::Helpers::SanitizeHelper

namespace :data do
  desc '성남시의원 데이터를 읽어서 에이전트로 등록합니다'
  task 'register_seongnam_councilor_to_agent' => :environment do
    path = Rails.root.join('data', '2018_07_seongnam_city_councilor.xlsx')
    xlsx = Roo::Spreadsheet.open path.to_s
    ActiveRecord::Base.transaction do
      position = Position.find_or_create_by!(name: '제8대 성남시의원')
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        puts row.inspect

        agent = Agent.new(
          name: row[0].cell_value,
          email: strip_tags(row[1].cell_value),
          organization: row[2].cell_value,
          category: '개인',
          remote_image_url: strip_tags(row[5].cell_value),
          election_region: "성남시 #{row[3].cell_value}"
        )

        agent.appointments.build(position: position)
        agent.save!
      end
    end
  end

  desc '제주도의원 데이터를 읽어서 에이전트로 등록합니다'
  task 'register_jejudo_councilor_to_agent' => :environment do
    path = Rails.root.join('data', '2018_08_jeju_do_councilor.xlsx')
    xlsx = Roo::Spreadsheet.open path.to_s
    ActiveRecord::Base.transaction do
      position = Position.find_or_create_by!(name: '제11대 제주특별자치도의원')
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        puts row.inspect

        agent = Agent.new(
          name: row[0].cell_value,
          email: strip_tags(row[1].cell_value),
          organization: row[2].cell_value,
          category: '개인',
          remote_image_url: strip_tags(row[5].cell_value),
          election_region: "제주시 #{row[3].cell_value}"
        )

        agent.appointments.build(position: position)
        agent.save!
      end
    end
  end

  desc '시/도의회의 데이터를 읽어서 에이전트로 등록합니다. '
  task 'register_councilor_to_agent', [:name, :file_name, :region] => :environment do |task, args|
    path = Rails.root.join('data', args[:file_name])
    xlsx = Roo::Spreadsheet.open path.to_s
    ActiveRecord::Base.transaction do
      position = Position.find_or_create_by!(name: args[:name])
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        puts row.inspect

        agent = Agent.new(
          name: row[0].cell_value,
          email: strip_tags(row[1].cell_value),
          organization: row[2].cell_value,
          category: '개인',
          remote_image_url: strip_tags(row[5].cell_value),
          election_region: "#{args[:name]} #{row[3].cell_value}"
        )

        agent.appointments.build(position: position)
        agent.save!
      end
    end
  end

  desc '국회의원 데이터가 비어있으면 로드합니다'
  task 'load_once_assembly_members' => :environment do
    if AssemblyMember.all.empty?
      AssemblyMember.refresh!
    end
  end

  desc '국회의원을 스피커로 등록합니다'
  task 'register_assembly_members_to_agent' => :environment do
    ActiveRecord::Base.transaction do
      AssemblyMember.all.select(:empNm, :assemEmail, :polyNm).each do |assembly_member|
        s = Agent.new(name: assembly_member[:empNm], organization: assembly_member[:polyNm],
         email: assembly_member[:assemEmail], category: '')
        s.position_name_list = '20대_국회의원'
        s.save!
      end
    end
  end

  desc '국회의원 정보를 갱신합니다'
  task 'reload_assembly_members' => :environment do
    AssemblyMember.update!
  end

  desc '국회의원의 이미지를 추가하고, 국회의원이 스피커가 되는 경우 스피커id를 넣어줍니다'
  task 'link_assembly_members_to_agent_and_add_image' => :environment do
    ActiveRecord::Base.transaction do
      Agent.of_position_names("20대_국회의원").each do |agent|
        member = AssemblyMember.find_by(empNm: agent.name, polyNm: agent.organization)
        member.agent_id = agent.id
        member.save!
        agent.remote_image_url = member.jpgLink
        agent.save!
      end
    end
  end

  desc '국회의원의 정보를 변경합니다'
  task 'update_assembly_20191025' => :environment do
    xlsx = Roo::Spreadsheet.open(Rails.root.join('lib', 'tasks', 'assembly_20191025.xlsx').to_s)
    ActiveRecord::Base.transaction do
      position = Position.find_by(name: '20대_국회의원')

      remain_agent_datas = []
      new_agents_datas = []
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        if empty_row?(row)
          break
        end

        attributes = %i(이름	정당	지역	선거구	의원회관	전화	팩스	트위터	페이스북	이메일	현역여부)
        data = {}
        attributes.each do |name|
          value = fetch_data(row, attributes, name).try(:strip)
          data[name] = value
        end

        agents = Agent.joins(:appointments)
          .where('agents.name': data[:이름])
          .where('appointments.position': position)
        if agents.count > 1
          agents = agents.where('agents.election_region': (data[:지역] == "비례대표" ? "비례대표" : "#{data[:지역]} #{data[:선거구]}"))
        end

        if agents.count > 1
          puts "multiple found : " + data.inspect
          puts "multiple found from db: " + agents.to_a.inspect
          abort
        elsif agents.count == 0
          puts "not found : " + data.inspect
          new_agents_datas << data
        else
          data[:agent] = agents.first
          remain_agent_datas << data
        end
      end
      remain_agent_datas.uniq!

      old_agents = Agent.joins(:appointments).where('appointments.position': position)
      puts "old count : #{old_agents.count}"

      remove_agents = old_agents.where.not(id: remain_agent_datas.map{ |remain_agent_data| remain_agent_data[:agent].id })
      puts "remove count : #{remove_agents.count}"
      remove_agents.each do |agent|
        agent.appointments.where(position: position).destroy_all
        puts "remove: #{agent.name} #{agent.organization}"
      end

      puts "remain count : #{remain_agent_datas.size}"
      remain_agent_datas.each do |data|
        agent = data[:agent]

        if "#{data[:지역]} #{data[:선거구]}".strip != agent.election_region
          new_election_region = "#{data[:지역]} #{data[:선거구]}"
          if data[:지역] != "비례대표" and data[:선거구] != "통영시고성군" and data[:지역] != '세종'
            puts "election_region error: db => [#{agent.election_region}] vs data => [#{new_election_region}]"
            agent.update_attributes!(election_region: new_election_region)
          end
        end

        agent.twitter = data[:트위터].presence
        agent.facebook = data[:페이스북].presence
        agent.organization = data[:정당]
        agent.email = data[:이메일].presence
        agent.save!
      end


      puts "new count : #{new_agents_datas.size}"
      new_agents_datas.each do |data|
        agent = Agent.find_by(name: data[:이름])
        if agent.present?
          puts "#{data[:이름]} : #{agent.image_url}"
        else
          puts "#{data[:이름]} : not found"
        end

        if data[:이름] == "정은혜"
          agent = Agent.new(name: data[:이름],
            remote_image_url: 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAFyRUt.img?h=660&w=540&m=6&q=60&o=f&l=f&x=244&y=271', category: '개인')
        end

        agent.appointments.build(position: position)
        agent.twitter = data[:트위터].presence
        agent.facebook = data[:페이스북].presence
        agent.organization = data[:정당]
        agent.email = data[:이메일].presence
        agent.save!
      end
    end
  end

  desc '국회의원의 정보를 변경합니다'
  task 'update_assembly_20200713' => :environment do
    xlsx = Roo::Spreadsheet.open(Rails.root.join('lib', 'tasks', 'assembly_20200713_photo.xlsx').to_s)
    ActiveRecord::Base.transaction do
      position = Position.find_by(name: '21대_국회의원')

      images = xlsx.images
      remain_agent_datas = []
      new_agents_datas = []
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        if empty_row?(row)
          break
        end

        attributes = %i(번호 이름 사진 정당	선수	지역	선거구	의원회관	전화	팩스	이메일	상임위)
        data = {}
        attributes.each do |name|
          value = fetch_data(row, attributes, name).try(:strip)
          data[name] = value
        end

        # agents = Agent.joins(:appointments)
        #   .where('agents.name': data[:이름])
        #   .where('appointments.position': position)
        # if agents.count > 1
        #   agents = agents.where('agents.election_region': (data[:지역] == "비례대표" ? "비례대표" : "#{data[:지역]} #{data[:선거구]}"))
        # end

        # if agents.count > 1
        #   puts "multiple found : " + data.inspect
        #   puts "multiple found from db: " + agents.to_a.inspect
        #   abort
        # elsif agents.count == 0
        #   puts "not found : " + data.inspect
          new_agents_datas << data
        # else
        #   data[:agent] = agents.first
        #   remain_agent_datas << data
        # end
      end
      # remain_agent_datas.uniq!

      # old_agents = Agent.joins(:appointments).where('appointments.position': position)
      # puts "old count : #{old_agents.count}"

      # remove_agents = old_agents.where.not(id: remain_agent_datas.map{ |remain_agent_data| remain_agent_data[:agent].id })
      # puts "remove count : #{remove_agents.count}"
      # remove_agents.each do |agent|
      #   agent.appointments.where(position: position).destroy_all
      #   puts "remove: #{agent.name} #{agent.organization}"
      # end

      # puts "remain count : #{remain_agent_datas.size}"
      # remain_agent_datas.each do |data|
      #   agent = data[:agent]

      #   if "#{data[:지역]} #{data[:선거구]}".strip != agent.election_region
      #     new_election_region = "#{data[:지역]} #{data[:선거구]}"
      #     if data[:지역] != "비례대표" and data[:선거구] != "통영시고성군" and data[:지역] != '세종'
      #       puts "election_region error: db => [#{agent.election_region}] vs data => [#{new_election_region}]"
      #       agent.update_attributes!(election_region: new_election_region)
      #     end
      #   end

      #   agent.twitter = data[:트위터].presence
      #   agent.facebook = data[:페이스북].presence
      #   agent.organization = data[:정당]
      #   agent.email = data[:이메일].presence
      #   agent.save!
      # end

      puts "new count : #{new_agents_datas.size}"
      new_agents_datas.each_with_index do |data, index|
        puts data[:사진]
        agent = Agent.find_by(name: data[:이름])
        if agent.present? && data[:선수] != '1선'
          puts "#{data[:이름]} #{data[:선수]}: #{agent.image_url}"

          agent.appointments.build(position: position)
          agent.organization = data[:정당]
          agent.email = strip_tags(data[:이메일].presence)
          agent.phone = strip_tags(data[:전화].presence)
          agent.fax = strip_tags(data[:팩스].presence)
          agent.election_region = (data[:지역] == "비례대표" ? "비례대표" : "#{data[:지역]} #{data[:선거구]}")
          agent.save!
        else
          puts "#{data[:이름]} #{data[:선수]} : not found"

          agent = Agent.new(
            name: data[:이름],
            email: strip_tags(data[:이메일].presence),
            phone: strip_tags(data[:전화].presence),
            fax: strip_tags(data[:팩스].presence),
            organization: data[:정당],
            category: '개인',
            election_region: (data[:지역] == "비례대표" ? "비례대표" : "#{data[:지역]} #{data[:선거구]}")
          )
          agent.image = File.open(images[index+1])
          agent.appointments.build(position: position)
          agent.save!
        end

        # if data[:이름] == "정은혜"
        #   agent = Agent.new(name: data[:이름],
        #     remote_image_url: 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AAFyRUt.img?h=660&w=540&m=6&q=60&o=f&l=f&x=244&y=271', category: '개인')
        # end

        # agent.appointments.build(position: position)
        # agent.twitter = data[:트위터].presence
        # agent.facebook = data[:페이스북].presence
        # agent.organization = data[:정당]
        # agent.email = data[:이메일].presence
        # agent.save!
      end

      #raise ActiveRecord::Rollback, "Test!!!"
    end
  end

  desc '국회의원의 정보를 변경합니다'
  task 'update_assembly' => :environment do
    ActiveRecord::Base.transaction do
      position = Position.find_by(name: '20대_국회의원')

      Agent.find_by(name: '권석창').appointments.where(position: position).destroy_all #이후삼
      Agent.find_by(name: '김경수').appointments.where(position: position).destroy_all #김정호
      Agent.find_by(name: '노회찬').appointments.where(position: position).destroy_all
      Agent.find_by(name: '문미옥').appointments.where(position: position).destroy_all #이수혁
      Agent.find_by(name: '박남춘').appointments.where(position: position).destroy_all #맹성규
      Agent.find_by(name: '박준영').appointments.where(position: position).destroy_all #서삼석
      Agent.find_by(name: '박찬우').appointments.where(position: position).destroy_all #이규희
      Agent.find_by(name: '배덕광').appointments.where(position: position).destroy_all #윤준호
      Agent.find_by(name: '송기석').appointments.where(position: position).destroy_all #송갑석
      Agent.find_by(name: '안철수').appointments.where(position: position).destroy_all #김성환
      Agent.find_by(name: '양승조').appointments.where(position: position).destroy_all #윤일규
      Agent.find_by(name: '윤종오').appointments.where(position: position).destroy_all #이상헌
      Agent.find_by(name: '최명길').appointments.where(position: position).destroy_all #최재성
      Agent.find_by(name: '오세정').appointments.where(position: position).destroy_all #임재훈
      Agent.find_by(name: '이군현').appointments.where(position: position).destroy_all #?
      Agent.find_by(name: '이철우').appointments.where(position: position).destroy_all #송언석

      Agent.find_by(id: 275, name: '최경환').update_attributes!(email: 'sayno20@hanmail.net')
      Agent.of_position_names("20대_국회의원").each do |agent|
        if %w(김성태 최경환).include? agent.name
          member = AssemblyMember.find_by(empNm: agent.name, assemEmail: agent.email)
        else
          member = AssemblyMember.find_by(empNm: agent.name)
        end

        member.agent_id = agent.id
        member.save!
        agent.organization = member.polyNm
        agent.email = member.assemEmail if member.assemEmail.present?
        agent.save!
      end

      %w(이후삼 김정호 이수혁 맹성규 서삼석 이규희 윤준호 송갑석 김성환 윤일규 이상헌 최재성 임재훈 송언석).each do |new_name|
        member = AssemblyMember.find_by(empNm: new_name)
        s = Agent.new(name: member.empNm, organization: member.polyNm,
         email: member.assemEmail, remote_image_url: member.jpgLink, category: '개인')
        s.appointments.build(position: position)
        s.save!
      end
    end
  end

  desc '국회의원의 선거구 정보를 업데이트합니다'
  task 'update_assembly2' => :environment do
    ActiveRecord::Base.transaction do
      Agent.of_position_names("20대_국회의원").each do |agent|
        if %w(김성태 최경환).include? agent.name
          member = AssemblyMember.find_by(empNm: agent.name, assemEmail: agent.email)
        else
          member = AssemblyMember.find_by(empNm: agent.name)
        end

        puts agent.name
        next if member.blank?

        agent.election_region = member.origNm
        agent.save!
      end
    end
  end

  desc '이벤트 이미지 데이터를 받습니다'
  task 'download_event', [:id] => :environment do |task, args|
    event = Event.find args[:id]
    Dir.mktmpdir do |dir|
      zipFileName = "event_#{event.id}.zip"
      Zip::File.open(zipFileName, Zip::File::CREATE) do |zipFile|
        event.comments.each do |comment|
          next if comment.read_attribute(:image).blank?
          puts comment.image.url
          file_name = "#{comment.id}_#{comment.read_attribute(:image)}"
          file_path = File.join(dir, file_name)
          if comment.image.file.respond_to?(:url)
            # s3
            File.open(file_path, 'wb') do |file|
              file << open(comment.image.url).read
            end
          else
            # local storage
            FileUtils.cp(comment.image.path, file_path)
          end
          zipFile.add(file_name, file_path)
        end
      end
    end
  end

  desc '630 단체 데이터를 넣습니다'
  task '630', [:file, :archive_id] => :environment do |task, args|
    xlsx = Roo::Spreadsheet.open args[:file]
    ActiveRecord::Base.transaction do
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        if empty_row?(row)
          break
        end
        model_instance = ArchiveDocument.new
        model_instance.build_additional
        process_model(row, model_instance, args[:archive_id])
      end
    end
  end

  desc "seed areas"
  task 'seed:areas' => :environment do
    count = 0
    ActiveRecord::Base.transaction do
      Area.delete_all
      now = DateTime.now
      Area.bulk_insert(:code, :division, :subdivision, :neighborhood, :created_at, :updated_at) do |worker|
        xlsx = Roo::Spreadsheet.open(Rails.root.join('lib', 'tasks', 'area_20180401.xlsx').to_s)

        index_area_division_code = 1
        index_area_subdivision_code = 3
        index_area_code = 5

        index_area_division = 2
        index_area_subdivision = 4
        index_area_neighborhood = 6

        xlsx.sheet("Data").each_row_streaming(pad_cells: true) do |row|
          division_code = row[index_area_division_code].try(:cell_value)
          next if division_code.blank?

          subdivision_code = row[index_area_subdivision_code].try(:cell_value)
          code = row[index_area_code].try(:cell_value)
          if code.blank?
            if subdivision_code.blank?
              code = division_code + "000" + "00"
            else
              code = subdivision_code + "00"
            end
          end

          division = row[index_area_division].try(:cell_value)
          subdivision = row[index_area_subdivision].try(:cell_value)
          neighborhood = row[index_area_neighborhood].try(:cell_value)

          worker.add [code, division, subdivision, neighborhood, now, now]
          count += 1
          print '.' if (count % 1000.0) == 0
        end
      end
    end
    puts '.' if count > 0
  end

  desc '2018년 제7회 지방선거 예비후보를 등록합니다'
  task 'register_regional_election_7th_precandidate' => :environment do
    count = 0

    candidate_category = Election::CANDIDATE_CATEGORY_20180613_PRECANDIDATE

    ActiveRecord::Base.transaction do
      ElectionCandidate.bulk_insert(:candidate_category, :district_name,
        :party, :image_url, :name, :election_slug,
        :election_category, :election_code, :area_division,
        :area_division_code, :district_slug, :district_code) do |worker|
        xlsx = Roo::Spreadsheet.open(Rails.root.join('lib', 'tasks', 'regional_election_7th_precandidate.xlsx').to_s)

        index_district_name = letter_to_number('b')
        index_party = letter_to_number('c')
        index_image_path = letter_to_number('d')
        index_name = letter_to_number('e')
        index_election_slug = letter_to_number('n')
        index_election_category = letter_to_number('o')
        index_election_code = letter_to_number('p')
        index_area_division = letter_to_number('q')
        index_area_division_code = letter_to_number('r')
        index_district_slug = letter_to_number('u')
        index_district_code = letter_to_number('v')

        xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
          no = row[0].try(:cell_value)
          next if no.blank?

          name = row[index_name].try(:cell_value)
          name = name.gsub /\(.*\)/, '' if name.present?
          next if name.blank?

          district_name = row[index_district_name].try(:cell_value)
          party = row[index_party].try(:cell_value)
          image_path = row[index_image_path].try(:cell_value)
          election_slug = row[index_election_slug].try(:cell_value)
          election_category = row[index_election_category].try(:cell_value)
          election_code = row[index_election_code].try(:cell_value)
          area_division = row[index_area_division].try(:cell_value)
          area_division_code = row[index_area_division_code].try(:cell_value)
          district_slug = row[index_district_slug].try(:cell_value)
          district_code = row[index_district_code].try(:cell_value)

          worker.add [candidate_category, district_name,
            party, ("http://info.nec.go.kr#{image_path}" if image_path.present?), name, election_slug,
            election_category, election_code, area_division,
            area_division_code, district_slug, district_code]
          count += 1
          print '.' if (count % 100.0) == 0
        end
      end

      print "agent 저장 중...\n"
      ElectionCandidate.where(election_slug: Election::SLUG_20180613, candidate_category: candidate_category).each do |election_candidate|


        s = Agent.new(name: election_candidate.name, category: '')
        s.remote_image_url = election_candidate.image_url
        s.position_name_list = '제7대_지방선거_예비후보'

        begin
          s.save!
        rescue ActiveRecord::RecordInvalid => e
          s.image = nil
        end
        s.save!

        election_candidate.agent = s
        election_candidate.save

        sleep 0.1

        count += 1
        print '.' if (count % 100.0) == 0
      end
    end
  end

  def empty_row? row
    row[0].nil? or row[0].formatted_value.try(:strip).blank?
  end

  def process_model(row, model_instance, archive_id)
    process_attributes(row, model_instance, archive_id)
    model_instance.user = User.find_by(nickname: '갱')
    model_instance.archive_id = archive_id
    model_instance.body = "#{model_instance.additional.address} #{model_instance.additional.homepage}"
    if model_instance.body.strip.blank?
      model_instance.body = model_instance.title
    end
    model_instance.save!
  end

  def process_attributes(row, model_instance, archive_id)
    parent_category = nil
    attributes = %i(category title tag1 tag2 sub_region npo_type address zipcode homepage tel fax leader leader_tel email)
    attributes.each do |name|
      process_method = :"process_bulk_of_#{name}"
      value = fetch_data(row, attributes, name).try(:strip)

      next if value.blank?
      if [:tag1, :tag2].include? name
        model_instance.tag_list.add(value)
      elsif :category == name
        category = ArchiveCategory.find_by(archive_id: archive_id, slug: value)
        if category.blank?
          category = ArchiveCategory.create!(archive_id: archive_id, slug: value, name: value)
        end
        parent_category = category
      elsif :sub_region == name
        slug = "#{parent_category.slug}-#{value}"
        category = ArchiveCategory.find_by(archive_id: archive_id, parent_id: parent_category.id, slug: slug)
        if category.blank?
          category = ArchiveCategory.create!(archive_id: archive_id, parent_id: parent_category.id, slug: slug, name: value)
        end
        model_instance.category_slug = category.slug
      elsif :title == name
        model_instance.assign_attributes(name => value)
      elsif :homepage == name
        model_instance.additional.assign_attributes(name => ActionView::Base.full_sanitizer.sanitize(value))
      else
        model_instance.additional.assign_attributes(name => value)
      end
    end

    print("#{parent_category.name}-#{model_instance.category.name} : #{model_instance.title}\n")
  end

  def fetch_data(row, attributes, name)
    row[attributes.index(name)].try(:formatted_value)
  end

  def letter_to_number(ch)
    ch.ord - 'a'.ord
  end
end
