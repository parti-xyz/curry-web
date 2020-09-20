Rails.application.routes.draw do
  class ShortDomainConstraint
    def matches?(request)
      short_domain = if Rails.env.production?
        ['cmz.kr']
      elsif Rails.env.staging?
        ['dev.cmz.kr']
      elsif Rails.env.development?
        ['cmz.test']
      else
        []
      end
      short_domain.include? request.host
    end
  end

  constraints(ShortDomainConstraint.new) do
    get '/', to: redirect { |params, req| "#{req.protocol}#{Rails.application.routes.default_url_options[:host]}" }
    get '/:slug', as: :short_slug_campaign, to: redirect { |params, req| "#{req.protocol}#{Rails.application.routes.default_url_options[:host]}/campaigns/#{ Campaign.find_by(slug: params[:slug]).try(:id) }" }, constraints: lambda { |request, params|
      Campaign.exists?(slug: params[:slug])
    }
    get '/:id', as: :short_id_campaign, to: redirect { |params, req| "#{req.protocol}#{Rails.application.routes.default_url_options[:host]}/campaigns/#{ params[:id] }" }, constraints: lambda { |request, params|
      Campaign.exists?(id: params[:id])
    }
  end

  mount Redactor2Rails::Engine => '/redactor2_rails'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

  get '404', :to => 'application#page_not_found'

  root 'campaigns#index'

  get 'about', to: 'pages#about', as: :about
  get 'components', to: 'pages#components'
  get 'privacy', to: "pages#privacy", as: 'privacy'
  get 'privacy/must', to: "pages#privacy_must", as: 'privacy_must'
  get 'privacy/option', to: "pages#privacy_option", as: 'privacy_option'
  get 'privacy/third', to: "pages#privacy_third", as: 'privacy_third'
  get 'terms', to: "pages#terms", as: 'terms'
  get 'marketing', to: "pages#marketing", as: 'marketing'
  get 'confirm_terms', to: "users#confirm_terms", as: 'users_confirm_terms'
  get 'notice', to: "pages#notice"

  post 'simple_mail/callback' => 'simple_mail#callback'

  resources :users
  resources :comments do
    get '/readers', on: :member, to: 'comments#readers'
  end
  resources :notes
  resources :likes do
    delete '/', on: :collection, to: 'likes#cancel'
  end
  resources :signs
  resources :reports
  resources :votes do
    collection do
      post :agree
      post :disagree
      post :neutral
      post :cancel
    end
  end

  get 'c/:slug', as: :slug_campaign, to: redirect { |params, req| "/campaigns/#{Campaign.find_by(slug: params[:slug]).id}"}, constraints: lambda { |request, params|
    Campaign.exists?(slug: params[:slug])
  }
  get 'events/:id', to: redirect { |params, req| "/campaigns/#{Campaign.find_by(previous_event_id: params[:id]).id}"}, constraints: lambda { |request, params|
    Campaign.exists?(previous_event_id: params[:id])
  }
  get 'petitions/:id', to: redirect { |params, req| "/campaigns/#{URI.escape(params[:id])}"}

  resources :projects, path: :p
  resources :episodes do
    collection do
      get 'change2020'
      get 'change2020_polls'
    end
  end
  resources :organizers
  resources :participations do
    delete :cancel, on: :collection
  end
  resources :speeches
  resources :statements
  concern :statementing do
    member do
      get 'edit_message_to_agent'
      put 'update_message_to_agent'
      get 'edit_agents'
      put 'add_agent'
      delete 'remove_agent'
      put 'add_action_target'
      delete 'remove_action_target'
      get 'new_comment_agent'
      get 'edit_statement'
      get 'edit_statements'

      get 'update_statement_agent', to: redirect{ |params, req| "#{ req.path.gsub(/update_statement_agent/, 'edit_statement') }?#{req.params.to_query}" }
    end
  end

  resources :project_categories
  resources :stories
  resources :discussions do
    member do
      put :unpin
      put :pin
    end
  end
  resources :discussion_categories
  resources :sympathies
  resources :campaigns, concerns: :statementing do
    resources :signs do
      collection do
        get 'mail_form'
        post 'mail'
      end
    end
    collection do
      get 'widget/v1/sdk', to: 'campaigns#widget_v1_sdk'
      get 'widget/v1/content', to: 'campaigns#widget_v1_content'
    end
    member do
      get 'data'
      get 'orders_data'
      put 'close'
      put 'open'
      get 'sign_form'
      get 'order_form'
      get 'picket_form'
      get 'comment_form'
      get 'orders'
      get 'need_to_order_agents'
      get 'agents'
      get 'comments'
      get 'comments_data'
      get 'stories'
      get 'signers'
      get 'contents'
      get 'pickets'
      get 'stories/:story_id', action: 'story', as: :story
      get 'picket'
      put 'stealthily'
    end
  end
  resources :polls do
    get 'social_card', on: :member
  end
  resources :surveys do
    get 'social_card', on: :member
  end
  post 'feedbacks', to: 'feedbacks#create'
  resources :wikis do
    shallow do
      resources :wiki_revisions do
        put 'revert', on: :member
      end
    end
  end
  resources :people do
    get :search, on: :collection
  end
  resources :races
  resources :players
  resources :thumbs

  resources :articles do
    post :create_by_slack, on: :collection
  end

  get 'unsubscribe', to: 'email_subscription#unsubscribe'
  post 'update_unsubscribe/:id', to: 'email_subscription#update', as: 'update_unsubscribe'

  get 'specials/voteaward2018'

  namespace :voteaward do
    resources :awards do
    end
    resources :votes do
    end

    get :welcome

    resources :users do
      member do
        get :confirm_email
        get :send_confirm_email
      end
    end

    root to: 'voteaward#welcome'
  end

  class AllTimelineConstraint
    def matches?(request)
      ["timeline", "list"].include? request.query_parameters["mode"]
    end
  end
  get '/archives/:id',
    to: redirect { |params, req| "/timelines/#{params[:id]}?mode=#{req.query_parameters["mode"]}" },
    constraints: AllTimelineConstraint.new
  resources :timelines do
    get 'download', on: :member
  end
  resources :timeline_documents
  resources :archives do
    get :recent_documents, on: :member
    resources :bulk_tasks do
      get :attachment, on: :member
      get :template, on: :collection
    end
    member do
      get :google_drive
      get '/categories/edit', to: 'archives#edit_categories'
      patch :update_categories
      get '/categories/:category_slug', to: 'archives#show', as: :category
    end
  end
  get '/bulk_tasks/start', to: 'bulk_tasks#start', as: :start_bulk_task
  resources :archive_documents do
    get :download, on: :member
  end
  resources :memorials
  get 'google_api/auth_callback', to: 'google_api#auth_callback', as: :auth_callback_google_api
  get 'google_api/auth', to: 'google_api#auth', as: :auth_google_api

  resources :agendas do
    member do
      get :new_email
      post :send_email
      get :widget
      get '/themes/widget/:theme_slug', action: :theme_single_widget, as: :theme_single_widget
    end
    collection do
      get '/themes/:theme_slug', action: :theme, as: :theme
      get '/themes/widget/:theme_slug', action: :theme_widget, as: :theme_widget
    end
  end
  resources :issues
  resources :following_issues
  resources :opinions, only: [:show] do
    member do
      get :vote_widget
    end
  end
  resources :agents do
    member do
      get :new_access_token
      get :create_access_token
    end
    get :search, on: :collection
  end
  resources :agencies do
    member do
      get :agents
    end
  end
  resources :orders do
    post :read, on: :collection
    get :beacon, on: :member
  end

  namespace :admin do
    root 'base#home', as: :home
    get :become, to: 'base#become'
    get :refresh_assembly_members, to: 'base#refresh_assembly_members'
    resources :agendas
    resources :issues do
      member do
        get :edit_campaigns
        get :search_campaigns
        put :add_campaigns
        delete :remove_campaigns
      end
    end
    resources :agencies
    resources :agents
    resources :positions
    resources :users, only: :index do
      member do
        put :ban
        put :unban
      end
    end
    resources :opinions do
      collection do
        get :new_or_edit
      end
    end
    resources :agenda_documents
    resources :agenda_themes do
      member do
        post :add_agenda
        delete :remove_agenda
      end
    end
    resources :roles do
      collection do
        post :add
        delete :remove
      end
    end
    resources :comments
    post '/download_emails', to: 'users#download_emails', as: :download_emails
  end

  mount LetterOpenerWeb::Engine, at: "/dev/emails"

  post 'api/v1/signs', to: 'api/v1/signs#create'
end
