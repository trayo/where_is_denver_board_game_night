ENV["RACK_ENV"] ||= "test"
require 'bundler'
Bundler.require

require 'simplecov'
SimpleCov.start

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
