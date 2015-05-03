require "sinatra"
require_relative "date_fetcher"

module BoardGameNight

  class Server < Sinatra::Base
    get '/' do
      l = DateFetcher.fetch.first
      erb :index, :locals => {date: l.first, location: l.last}
    end

    not_found do
      erb :error
    end
  end
end
