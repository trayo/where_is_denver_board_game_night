module BoardGameNight
  class Server < Sinatra::Base
    get '/' do
      l = Location.first
      erb :index, locals: {date: l.date, name: l.name}
    end

    get '/directions' do
      location = Location.first.name.gsub(" ", "+")
      redirect "https://www.google.com/maps/dir/Current+Location/#{location}"
    end

    not_found do
      erb :error
    end
  end
end
