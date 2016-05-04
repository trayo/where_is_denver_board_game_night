require "./test/test_helper"
require "./app/models/event"

module BoardGameNight
  class LocationFetcherTest < Minitest::Test

    def test_it_can_purge_old_events
      Event.create(date: Date.yesterday)
      Event.create(date: Date.today)

      assert_equal 2, Event.count

      Event.purge

      assert_equal 1, Event.count
    end
  end
end
