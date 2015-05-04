module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      @location = Location.first
      erb :index, :locals => {date: l.first, location: l.last}
    end

    # get '/directions' do
    #   automatically open google maps directions
    # end

    not_found do
      erb :error
    end
  end
end
