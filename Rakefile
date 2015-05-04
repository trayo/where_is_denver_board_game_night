require "bundler"
Bundler.require
require 'rake/testtask'
require "sinatra/activerecord/rake"
require_relative "app/models/location_fetcher"

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

task default: :test

task :environment do
  require File.expand_path('config/environment', File.dirname(__FILE__))
end

desc "Update the database with locations from r/denver"
task :update_locations => :environment do
  puts "Fetching dates and locations from reddit..."
  BoardGameNight::LocationFetcher.update
  puts "Done!"
end

