module BoardGameNight
  class Server < Sinatra::Base

    EVENT_NOT_FOUND = "Oops! I didn't find the next event and location."

    get '/' do
      if event = Event.first
        slim :index, locals: { date: event.date, location: event.name }
      else
        slim :error, locals: { message: EVENT_NOT_FOUND }
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
        slim :error, locals: { message: EVENT_NOT_FOUND }
      end
    end

    get '/next_week' do
      if event = Event.second
        slim :index, locals: { date: event.date, location: event.name }
      else
        slim :error, locals: { message: EVENT_NOT_FOUND }
      end
    end

    get '/next_week/next_week' do
      if event = Event.third
        slim :index, locals: { date: event.date, location: event.name }
      else
        slim :error, locals: { message: EVENT_NOT_FOUND }
      end
    end

    get '/update_events' do
      Event.purge
      redirect "/"
    end

    not_found do
      slim :error
    end
  end
end
