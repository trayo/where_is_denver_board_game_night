# Where is r/denver board game night?

[![Circle CI](https://circleci.com/gh/trayo/where_is_denver_board_game_night.svg?style=svg)](https://circleci.com/gh/trayo/where_is_denver_board_game_night)
[![Stories in Ready](https://badge.waffle.io/trayo/where_is_denver_board_game_night.svg?label=ready&title=Ready)](http://waffle.io/trayo/where_is_denver_board_game_night)

This is the source code for the [r/Denver](http://www.reddit.com/r/Denver/) Wednesday board game group that tells you, simply, where board game night is located. I was inspired by [is there a fucking rockies game](https://github.com/baer/isThereAFuckingGame) and thought that board game night needed something similar.
### [Check it out on Heroku!](https://whereisdenverboardgamenight.herokuapp.com/)

### Nifty Features

`/next_week` will show you next weeks location.

`/next_week/next_week` will show you next next weeks location.

`/directions` will attempt to show you Google Maps directions to the current location.

`/update_events` will delete events older than today from the database, *hopefully* updating the event to the next one.

### The stack

"Where is r/dever board game night?" is built on [Sinatra](http://www.sinatrarb.com/). It uses [PostgreSQL](http://www.postgresql.org/) and [ActiveRecord](https://github.com/janko-m/sinatra-activerecord) for easy access to data. It fetches new dates and locations from the [r/Denver/wiki](http://www.reddit.com/r/Denver/wiki/wednesdaymeetup) using [Nokogiri](http://www.nokogiri.org/).

### License

[MIT License](http://opensource.org/licenses/MIT)
