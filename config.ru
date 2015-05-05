require 'bundler'
Bundler.require

require 'dotenv'
Dotenv.load

require File.expand_path('../config/environment',  __FILE__)

run BoardGameNight::Server

