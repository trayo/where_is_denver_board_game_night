ENV["RACK_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "bundler"
Bundler.require

require "simplecov"
SimpleCov.start

require "capybara"
Capybara.app = BoardGameNight::Server

require File.expand_path("../../config/environment", __FILE__)
require "minitest/autorun"
require "minitest/pride"
require "vcr"
require "capybara"

