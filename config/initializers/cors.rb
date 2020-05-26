Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: (!Rails.env.production?), logger: (-> { Rails.logger }) do
  allow do
    origins '*'
    resource '/timelines/*.json', headers: :any, methods: [:get]
  end

  allow do
    origins '*'
    resource '/campaigns/widget/*', headers: :any, methods: [:get]
  end
end
