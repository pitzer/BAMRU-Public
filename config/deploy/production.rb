server 'bamru.org', :app, :web, :primary => true

desc "This is a production only task"
task :zzz do
  run "uptime"
end
