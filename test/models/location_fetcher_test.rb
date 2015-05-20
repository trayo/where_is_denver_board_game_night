require "./test/test_helper"
require "./app/models/location_fetcher"

module BoardGameNight
  class LocationFetcherTest < Minitest::Test

    def setup
      # stubs stdout to silence output from 'puts'
      @original_stdout = $stdout
      $stdout = StringIO.new
    end

    def teardown
      $stdout = @original_stdout
      Location.destroy_all
      Event.destroy_all
    end

    def days_from_now(num)
      Time.now.advance(days: num).to_date
    end

    def test_it_can_fetch_from_reddit
      dates_and_locations = []

      VCR.use_cassette "fetch from reddit" do
        dates_and_locations = LocationFetcher.fetch_dates_and_locations
      end

      assert_equal 8, dates_and_locations.length
      assert_equal "May 6th: Diebolt Brewing", dates_and_locations.first
    end

    def test_it_parses_fetched_lines
      lines = [
        "April 11th 2200: Tabletop Day at Irish Snug",
        "April 15th 2200: Diebolt Brewing"
      ]

      expected = {
        Date.parse("April 11th 2200") => "Tabletop Day at Irish Snug",
        Date.parse("April 15th 2200") => "Diebolt Brewing"
      }

      assert_equal expected, LocationFetcher.new(lines).lines
    end

    def test_it_creates_new_events_and_locations
      lines = [
        "#{days_from_now(4)}: Tabletop Day at Irish Snug",
        "#{days_from_now(9)}: Diebolt Brewing"
      ]

      LocationFetcher.new(lines).create_events_and_locations

      assert_equal 2, Location.count
      assert_equal "Diebolt Brewing", Location.last.name
      assert_equal 2, Event.count
      assert_equal days_from_now(9), Event.last.date
    end

    def test_it_doesnt_overwrite_existing_events_and_locations
      l = Location.create(name: "Super Smash Brewery")
      l.events << Event.create(date: days_from_now(3))

      lines = ["#{days_from_now(3)}: Super Smash Brewery"]
      LocationFetcher.new(lines).create_events_and_locations

      assert_equal 1, Location.count
      assert_equal 1, Event.count
    end

    def test_it_updates_an_existing_location
      l = Location.create(name: "TBD/TBA")
      l.events << Event.create(date: days_from_now(5))

      lines = ["#{days_from_now(5)}: Die Hard Brews"]
      LocationFetcher.new(lines).create_events_and_locations

      assert_equal 1, Location.count
      assert_equal "Die Hard Brews", Location.first.name
      assert_equal 1, Event.count
    end

    def test_it_deletes_old_events_that_already_happened
      Event.create(date: Date.yesterday)
      lines = [
        "#{Date.yesterday}: Captains Log Brewery",
        "#{days_from_now(5)}: Die Hard Brews"
      ]

      LocationFetcher.new(lines).create_events_and_locations

      assert_equal 1, Event.count
    end
  end
end

