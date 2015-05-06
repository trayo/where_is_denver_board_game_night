require "./test/test_helper"
require "./app/models/location_fetcher"

module BoardGameNight
  class LocationFetcherTest < Minitest::Test

    def setup
      @original_stdout = $stdout
      $stdout = StringIO.new
    end

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

    def test_it_can_delete_all_locations
      4.times { |i| Location.create(date: Date.tomorrow, name: "#{i}") }
      assert_equal 4, Location.count

      LocationFetcher.destroy_locations
      assert_equal 0, Location.count
    end

    def test_it_can_fetch_from_reddit
      VCR.use_cassette "fetch from reddit" do
        LocationFetcher.update_locations
      end

      assert_equal 3, Location.count
    end

    def teardown
      $stdout = @original_stdout
      Location.destroy_all
    end
  end
end

