require "nokogiri"
require "open-uri"

module BoardGameNight
  class DateFetcher

    def self.fetch

      doc = Nokogiri::HTML(open("http://www.reddit.com/r/Denver/wiki/wednesdaymeetup"))

      lines = doc.at_css("#wiki_tentative_schedule").next_element.children.map(&:text)

      lines.delete("\n")

      lines.map! {|l| l.split(": ")}

      lines.map! do |date, loc|
        [Date.parse(date), loc]
      end

      lines.drop_while {|l| l.first < Date.today}
    end

  end
end

