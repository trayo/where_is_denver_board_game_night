require "open-uri"

module BoardGameNight
  class LocationFetcher
    REDDIT_URL = "https://www.reddit.com/r/Denver/wiki/wednesdaymeetup"
    REDDIT_CSS = "#wiki_tentative_schedule"
    USER_AGENT = "5HhN6lAq9FNy7g:amtNaB24vp-5z8NLulnXnRWz5Cs:v1.0.0 (by /u/trayo)"

    def self.update_events_and_locations
      new(fetch_dates_and_locations).create_events_and_locations
    end

    def self.fetch_dates_and_locations
      Nokogiri::HTML(open(REDDIT_URL, "User-Agent" => USER_AGENT))
      .at_css(REDDIT_CSS)
      .next_element
      .children
      .map(&:text)
      .map(&:strip)
      .delete_if(&:empty?)
    end

    attr_reader :lines

    def initialize(lines)
      @lines = parse(lines).to_h
      remove_old_events_and_locations
      @dates, @locations = @lines.keys, @lines.values
    end

    def create_events_and_locations
      @lines.each do |date, location_name|
        location = Location.find_by("name LIKE ?", location_name)
        event = Event.find_or_create_by(date: date)

        if location && location.events.include?(event)
          puts "Already created: #{location.name} on #{formatted(event.date)}."
        elsif location && !location.name.include?("TB")
          puts "Added event: #{formatted(event.date)} to #{location.name}"
          location.events << event
        elsif event.location
          event.location.update_attributes(name: location_name)
          puts "Updated: #{event.location.name} on #{formatted(event.date)}."
        else
          location = Location.create(name: location_name)
          location.events << event
          puts "New location: #{location.name} on #{formatted(event.date)}."
        end
      end
    end

    private

    def remove_old_events_and_locations
      @lines.each do |date, _location|
        if before_today?(date) && event = Event.find_by(date: date)
          event.destroy
        end
      end
      @lines.reject! { |date, _location| before_today?(date) }
    end

    def formatted(date)
      date.strftime("%A %B %d, %Y")
    end

    def before_today?(date)
      date < Date.today
    end

    def parse(lines)
      lines.map do |line|
        date, location = line.split(": ")
        [Date.parse(date), location.delete("[]()")]
      end
    end
  end
end
