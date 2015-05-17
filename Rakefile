require "bundler"
Bundler.require

require_relative "app/server.rb"
require "rake/testtask"
require "sinatra/activerecord/rake"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task default: :test

desc "Hopefully lets you mess about with active record"
task :console => :environment do
  BoardGameNight::Console.run
end

desc "Sets up the environment for :update_events"
task :environment do
  require File.expand_path("config/environment", File.dirname(__FILE__))
end

desc "Update the database with events and locations from r/denver"
task :update_events_and_locations => :environment do
  if Date.today.thursday?
    puts "Fetching dates and locations from reddit..."
    BoardGameNight::LocationFetcher.update_events_and_locations
    puts "Done!"
  else
    puts "It's not Thursday so I didn't update."
  end
end

desc "Forcefully updates the database with locations"
task :force_update => :environment do
  puts "Fetching dates and locations from reddit..."
  BoardGameNight::LocationFetcher.update_events_and_locations
  puts "Done!"
end

desc "Wipe all locations from the database"
task :destroy_locations => :environment do
  puts "Destroying locations..."
  l = BoardGameNight::Location.destroy_all
  puts "Done! #{l.count} locations destroyed."
end

desc "Wipe all events from the database"
task :destroy_events => :environment do
  puts "Destroying events..."
  e = BoardGameNight::Event.destroy_all
  puts "Done! #{e.count} events destroyed."
end


