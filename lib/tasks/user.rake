namespace :user do
  def reset_counter(ids, modelClass, column)
    ids.each do |id|
      next unless modelClass.exists?(id: id)
      modelClass.reset_counters(id, column)
    end
  end

  desc "회원을 탈퇴처리합니다"
  task :delete, [:nickname] => :environment do |task, args|
    ActiveRecord::Base.transaction do
      user = User.find_by(nickname: args.nickname)
      if user.blank?
        puts '해당되는 회원이 없습니다.'
        next
      end

      user.destroy!
    end
  end
end
