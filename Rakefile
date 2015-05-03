require "bundler"
Bundler.require
require 'rake/testtask'
require "sinatra/activerecord/rake"
require_relative "app/models/date_fetcher"

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

task default: :test

desc "Update the database with locations from r/denver"
task :update_locations do
  puts "Fetching dates and locations from reddit..."
  DateFetcher.update
  puts "done."
end

