require "open-uri"

module BoardGameNight

  class LocationFetcher

    def self.update_locations
      new(fetch_dates_and_locations).create_locations
    end

    def self.fetch_dates_and_locations
      Nokogiri::HTML(open("http://www.reddit.com/r/Denver/wiki/wednesdaymeetup"))
      .at_css("#wiki_tentative_schedule").next_element.children.map(&:text)
    end

    def self.destroy_locations
      Location.destroy_all
    end

    attr_reader :lines

    def initialize(lines)
      @lines = parse(lines)
    end

    def create_locations
      @lines.each do |date, location|
        if after_today_and_doesnt_exist?(date)
          l = Location.create(date: date, name: location)
          puts "Location #{l.name} on #{l.date} created!"
        elsif before_today_and_does_exist?(date)
          l = Location.find_by(date: date).destroy
          puts "Location #{l.name} destroyed!"
        else
          print_date_before_today_or_already_exists(date, location)
        end
      end
    end

    private

    def print_date_before_today_or_already_exists(date, location)
      if date < Date.today
        puts "Already happened #{location} on #{date}."
      else
        puts "Already added #{location} on #{date}."
      end
    end

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
