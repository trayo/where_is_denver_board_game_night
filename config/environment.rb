# require gems
require "bundler"
Bundler.require

require "sinatra"
require "tilt/erb"

# set the pathname for the root of the app
require "pathname"
APP_ROOT = Pathname.new(File.expand_path("../../", __FILE__))

# require the server
require_relative "../app/server"

# require the model
Dir[APP_ROOT.join("app", "models", "*.rb")].each { |file| require file }

# require database configurations
require APP_ROOT.join("config", "database")

# configure Server settings
module BoardGameNight
  class Server < Sinatra::Base
    set :method_override, true
    set :root, APP_ROOT.to_path
    set :views, File.join(BoardGameNight::Server.root, "app", "views")
    set :public_folder, File.join(BoardGameNight::Server.root, "app", "public")
  end
end
