module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      if event = Event.first
        erb :index, locals: { date: event.date, location: event.name }
      else
        erb :error, locals: { message: event_not_found }
      end
    end

    get '/directions' do
      event = Event.first

      if event && event.address
        redirect "https://www.google.com/maps/dir/Current+Location/#{event.address}"
      elsif event
        location_name = event.name.gsub(" ", "+")
        redirect "https://www.google.com/maps/dir/Current+Location/#{location_name}"
      else
        erb :error, locals: { message: location_not_found }
      end
    end

    not_found do
      erb :error
    end

    private

    def event_not_found
      "Oops! I didn't find the next event and location."
    end
  end
end
