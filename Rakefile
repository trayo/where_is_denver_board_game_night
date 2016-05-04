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
  if BoardGameNight::Event.first.date < Date.today
    puts "Fetching dates and locations from reddit...\n"
    BoardGameNight::LocationFetcher.update_events_and_locations
    puts "\nDone!"
  else
    puts "Next event is after today so I didn't update."
  end
end

desc "Destroys events and locations and then force updates"
task :destroy_and_force_update => [ :destroy_events_and_locations, :force_update ]

desc "Destroys events and locations"
task :destroy_events_and_locations => [ :destroy_events, :destroy_locations ]

desc "Not typically used: Forcefully updates the database with events and locations"
task :force_update => :environment do
  puts "Fetching dates and locations from reddit...\n\n"
  BoardGameNight::LocationFetcher.update_events_and_locations
  puts "\nDone!"
end

desc "Destroys all locations from the database"
task :destroy_locations => :environment do
  puts "Destroying locations...\n"
  l = BoardGameNight::Location.destroy_all
  puts "\nDone! #{l.count} locations destroyed."
end

desc "Destroys all events from the database"
task :destroy_events => :environment do
  puts "Destroying events...\n"
  e = BoardGameNight::Event.destroy_all
  puts "\nDone! #{e.count} events destroyed."
end

desc "Purge events older than today"
task :purge_events => :environment do
  puts "Purging events...\n"
  e = BoardGameNight::Event.purge
  puts "\nDone! #{e.count} events purged."
end
