desc "This task is called by the Heroku scheduler add-on"
task :drop_records => :environment do
  puts "Removing old locations..."
  @locations = Location.where("created_at >?", 3.days.ago)
  puts "done."
end