# Where the fuck is board game night?

This is the source code for the [r/Denver](http://www.reddit.com/r/Denver/)
Wednesday board game group website that tells you, simply, where board game night
is located.

I was inspired by [is there a fucking rockies game](https://github.com/baer/isThereAFuckingGame)
and thought that we needed something similar for board game night.

### The stack

"Where the fuck is board game night?" is built on [Sinatra](http://www.sinatrarb.com/).
It uses [PostgreSQL](http://www.postgresql.org/) and
[ActiveRecord](https://github.com/janko-m/sinatra-activerecord) for easy access to data.
It fetches new dates and locations from the [r/Denver/wiki](http://www.reddit.com/r/Denver/wiki/wednesdaymeetup)
using [Nokogiri](http://www.nokogiri.org/).
