require './test/test_helper'
require "./app/models/location_fetcher"

module BoardGameNight
  class LocationFetcherTest < Minitest::Test
    def test_it_parses_fetched_lines
      lines = [
        "\n",
        "April 11th: Tabletop Day at Irish Snug",
        "\n",
        "April 15th: Diebolt Brewing"
      ]

      expected = [
        [Date.parse("April 11th"), "Tabletop Day at Irish Snug"],
        [Date.parse("April 15th"), "Diebolt Brewing"]
      ]

      assert_equal expected, LocationFetcher.new(lines).lines
    end

    def test_it_creates_locations
      lines = [
        "#{Time.now.advance(days: 3).to_date}: Tabletop Day at Irish Snug",
        "#{Time.now.advance(days: 9).to_date}: Diebolt Brewing"
      ]

      LocationFetcher.new(lines).create_locations

      assert_equal 2, Location.count
      assert_equal "Diebolt Brewing", Location.last.name
    end

    def test_it_deletes_dates_that_have_passed
      Location.create(date: Date.yesterday, name: "My Location")
      lines = [
        "#{Date.yesterday}: My Location",
        "#{Time.now.advance(days: 9).to_date}: Diebolt Brewing"
      ]

      assert_equal 1, Location.count

      LocationFetcher.new(lines).create_locations

      assert_equal 1, Location.count
      assert_equal "Diebolt Brewing", Location.first.name
      assert_nil Location.find_by(name: "My Location")
    end

    def test_it_doesnt_delete_today
      Location.create(date: Date.today, name: "wow. such location")
      lines = [
        "#{Date.today}: wow. such location",
        "#{Time.now.advance(days: 7).to_date}: wow. such location",
      ]

      LocationFetcher.new(lines).create_locations

      assert_equal 2, Location.count
      assert_equal "wow. such location", Location.first.name
    end

    def teardown
      Location.destroy_all
    end
  end
end

#     LINES = [
#       "\n",
#       "April 11th: Tabletop Day at Irish Snug",
#       "\n",
#       "April 15th: Diebolt Brewing",
#       "\n",
#       "April 22nd: Wit's End ",
#       "\n",
#       "April 29th: Beryls Brewing ",
#       "\n",
#       "May 6th: Diebolt Brewing",
#       "\n",
#       "May 13th: Strange Craft Brewing ",
#       "\n",
#       "May 20th: Bicycle Cafe",
#       "\n",
#       "May 27th: Black Sky ",
#       "\n"
#     ]
