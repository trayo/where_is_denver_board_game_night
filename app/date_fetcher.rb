require "nokogiri"
require "open-uri"

class DateFetcher

  def self.update
    doc = Nokogiri::HTML(open("http://www.reddit.com/r/Denver/wiki/wednesdaymeetup"))

    lines = doc.at_css("#wiki_tentative_schedule").next_element.children.map(&:text)

    lines.delete("\n")

    lines.map! {|l| l.split(": ")}

    lines.map! do |date, location|
      date = Date.parse(date)
      [date, location] if date > Date.today
    end.compact!
  end
end

