class Ability
  include CanCan::Ability

  def initialize(user, params = {})
    can [:read, :search, :social_card, :recent_documents], :all
    can :create, [Sign, Comment, Like, Note]
    can :cancel, Like
    can :create_by_slack, Article
    can :download, Timeline
    can [:widget, :new_email, :send_email, :theme, :theme_widget, :theme_single_widget], Agenda
    can :vote_widget, Opinion
    can [:agenda, :new_access_token, :create_access_token, :search], Agent
    can [:new_comment_agent], :all
    can [:download], ArchiveDocument
    can [:edit_statement, :readers], :all
    can [:edit_statements], [Campaign]
    can [:sign_form, :order_form, :picket_form, :orders, :agents, :comments, :stories, :story, :signers, :contents, :pickets, :picket, :agents, :need_to_order_agents, :widget_v1_sdk, :widget_v1_content], Campaign

    if user
      can [:new_email, :send_email], Agenda
      can :create, [
          Project, Discussion, DiscussionCategory, Poll, Feedback, Survey, Wiki, Sympathy,
          Memorial, Timeline, TimelineDocument,
          Article, Person, Race, Player,
          Thumb
        ]

      # 서명 만들기
      can :create_campaign, [Organization] do |organization|
        organization.blank? or organization.projects.any?{ |project| project.organizer?(user) }
      end
      can :create_campaign, [Project] do |project|
        project.blank? or project.organizer?(user)
      end
      can :create, [Campaign] do |campaign|
        project = campaign.try(:project) || (Project.find_by(slug: params[:project_id]) if params[:project_id].present?)
        project.blank? or project.organizer?(user)
      end

      can [:update, :destroy], [
          Project, Discussion, DiscussionCategory, Campaign, Poll, Survey, Wiki, Sympathy,
          Memorial, Timeline, TimelineDocument,
          Sign, Article, Person,
          Race, Player
        ], :user_id => user.id
      can :update, Project do |project|
        user == project.user or project.organizer?(user)
      end

      can :pin, Discussion do |discussion|
        user == discussion.user or discussion.try(:project).try(:organizer?, user)
      end

      can [:edit_agents, :add_agent, :remove_agent, :add_action_target, :remove_action_target, :edit_message_to_agent, :update_message_to_agent, :open, :close, :stealthily, :comments_data, :data, :orders_data], [Campaign] do |action|
        user == action.user or action.try(:project).try(:organizer?, user)
      end
      can [:mail_signs], Campaign do |campaign|
        user == campaign.user or campaign.project.try(:organizer?, user)
      end

      can [:create, :update], [Statement] do |statement|
        statementable = statement.statementable
        statementable.present? and can?(:update, statementable)
      end

      can :destroy, Comment do |comment|
        next true if comment.toxic == false and user == comment.user
        next true if comment.commentable.is_a?(Campaign) and comment.commentable.user == user
        if comment.commentable.try(:project)
          next ( user == comment.commentable.project.user or comment.commentable.project.organizer?(user) )
        end

        false
      end

      can :manage, Note do |note|
        user == note.user
      end

      can :data, [Campaign], user_id: user.id

      # 관심 이슈 등록
      can :manage, [FollowingIssue], user_id: user.id

      # 기관
      can :agents, Agency

      # 모든 회원은 위키를 수정하고 원복할 수 있다
      can [:update], Wiki
      can [:revert], WikiRevision

      # 프로젝트 개설자 및 운영자는 프로젝트에 속한 글을 삭제할 수 있다
      can [:destroy, :update], [Discussion, DiscussionCategory, Campaign, Poll, Survey, Wiki] do |model|
        model.project && ( user == model.project.user or model.project.organizer?(user) )
      end


      # 프로젝트 개설자 및 운영자는 프로젝트 운영자를 관리할 수 있다
      can :manage, Organizer do |organizer|
        if organizer.persisted?
          organizer.organizable && organizer.organizable.organizer?(user)
        elsif params[:organizer][:organizable_type].present?
          model = params[:organizer][:organizable_type].safe_constantize
          next false if model.blank?

          organizable = model.find_by id: params[:organizer][:organizable_id]
          organizable.organizer?(user)
        end
      end
      can :update_organizers, [Project, Organization] do |organizable|
        organizable.organizer?(user)
      end

      # 소식
      can [:update, :destroy], Story, :user_id => user.id
      # 해당 개설자 및 운영자는 소식을 삭제할 수 있다
      can [:destroy, :update], Story do |story|
        if story.storiable.respond_to?(:user)
          next true if user == story.storiable.user
        end

        if story.storiable.respond_to?(:organizer?)
          next true if story.storiable.organizer?(user)
        end

        if story.storiable.respond_to?(:project) and story.storiable.project.present?
          next true if story.storiable.project.organizer?(user)
        end

        false
      end
      can [:create], Story
      can [:create_story], Project do |project|
        project.organizer?(user)
      end
      can [:create_story], Campaign do |campaign|
        campaign.user == user
      end

      begin
        if user.has_role? :admin
          can :manage, :all
        end
      rescue NameError => e
        Rails.logger.error user.inspect
        raise e
      end
    end
  end
end
