module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      location = Location.first
      if location
        erb :index, locals: {date: location.date, name: location.name}
      else
        erb :error, locals: {message: location_not_found}
      end
    end

    get '/directions' do
      if Location.first
        location = Location.first.name.gsub(" ", "+")
        redirect "https://www.google.com/maps/dir/Current+Location/#{location}"
      else
        erb :error, locals: {message: location_not_found}
      end
    end

    not_found do
      erb :error
    end

    private

    def location_not_found
      "Oops! I didn't find the next location."
    end
  end
end
