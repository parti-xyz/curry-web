on_app_servers do
  sudo "sleep 20s ; monit start all -g #{config.app}_sidekiq"
  run "bundle exec rake data:load_once_assembly_members"
  run "bundle exec rake sitemap:refresh"
end
