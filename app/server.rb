module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      if event = Event.first
        slim :index, locals: { date: event.date, location: event.name }
      else
        slim :error, locals: { message: event_not_found }
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
        slim :error, locals: { message: event_not_found }
      end
    end

    get '/next_week' do
      if event = Event.second
        slim :index, locals: { date: event.date, location: event.name }
      else
        slim :error, locals: { message: event_not_found }
      end
    end

    get '/next_week/next_week' do
      if event = Event.third
        slim :index, locals: { date: event.date, location: event.name }
      else
        slim :error, locals: { message: event_not_found }
      end
    end

    get '/update_events' do
      Event.purge
      redirect "/"
    end

    not_found do
      slim :error
    end

    private

    def event_not_found
      "Oops! I didn't find the next event and location."
    end
  end
end
