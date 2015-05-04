require "open-uri"

module BoardGameNight

  class LocationFetcher

    def self.update
      new(fetch_dates_and_locations).create_locations
    end

    def self.fetch_dates_and_locations
      Nokogiri::HTML(open("http://www.reddit.com/r/Denver/wiki/wednesdaymeetup"))
        .at_css("#wiki_tentative_schedule").next_element.children.map(&:text)
    end

    attr_reader :lines

    def initialize(lines)
      @lines = parse(lines)
    end

    def create_locations
      @lines.each do |date, location|
        if after_today_and_doesnt_exist?(date)
          Location.create(date: date, name: location)
        elsif before_today_and_does_exist?(date)
          Location.find_by(date: date).destroy
        end
      end
    end

    private

    def after_today_and_doesnt_exist?(date)
      date > Date.today && !Location.exists?(date: date)
    end

    def before_today_and_does_exist?(date)
      date < Date.today && Location.exists?(date: date)
    end

    def parse(lines)
      lines.delete("\n")
      lines.map! { |l| l.split(": ") }
      lines.each { |l| l[0] = Date.parse(l[0]) }
    end
  end
end
