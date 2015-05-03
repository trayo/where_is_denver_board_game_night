require "nokogiri"
require "open-uri"

doc = Nokogiri::HTML(open("http://www.reddit.com/r/Denver/wiki/wednesdaymeetup#wiki_tentative_schedule"))

lines = doc.at_css("#wiki_tentative_schedule").next_element.children.map(&:text)

lines.delete("\n")

lines.map! {|l| l.split(": ")}

lines.map! do |date, loc|
  [Date.parse(date), loc]
end

