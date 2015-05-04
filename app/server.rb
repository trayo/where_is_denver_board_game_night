module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      l = Location.first
      erb :index, locals: {date: l.date, name: l.name}
    end

    # get '/directions' do
    #   automatically open google maps directions
    # end

    not_found do
      erb :error
    end
  end
end
