module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      l = DateFetcher.update.first
      erb :index, :locals => {date: l.first, location: l.last}
    end

    not_found do
      erb :error
    end
  end
end
