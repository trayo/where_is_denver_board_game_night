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
    end

    def test_it_parses_fetched_lines
      lines = [
        "\n",
        "April 11th 2200: Tabletop Day at Irish Snug",
        "\n",
        "April 15th 2200: Diebolt Brewing"
      ]

      expected = {
        Date.parse("April 11th 2200") => "Tabletop Day at Irish Snug",
        Date.parse("April 15th 2200") => "Diebolt Brewing"
      }

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

    def test_it_can_fetch_from_reddit
      VCR.use_cassette "fetch from reddit" do
        LocationFetcher.update_locations
      end

      assert_equal 3, Location.count
    end
  end
end

