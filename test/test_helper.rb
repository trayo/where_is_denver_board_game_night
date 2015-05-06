ENV["RACK_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "bundler"
Bundler.require

require "simplecov"
SimpleCov.start

require "capybara"
Capybara.app = BoardGameNight::Server

require "webmock"
require "vcr"
VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

require File.expand_path("../../config/environment", __FILE__)
require "minitest/autorun"
require "minitest/pride"
require "capybara"

