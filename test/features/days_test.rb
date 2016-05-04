require "./test/test_helper"

module BoardGameNight
  class DaysTest < Minitest::Test
    include Capybara::DSL

    WEEKDAY_MONTH_DAY_YEAR = "%A, %B %d %Y"

    def setup
      silence_stdout
    end

    def teardown
      unsilence_stdout
      Location.destroy_all
      Event.destroy_all
    end

    def test_it_shows_an_error_when_there_are_no_locations
      visit "/"

      expected = "Oops!"

      assert has_content?(expected), error_didnt_find(expected)
    end

    def test_a_location_when_date_is_before_today
      next_board_game_night = "The next board game night is"
      location_name = "yesterday brewery"

      location = Location.create(name: location_name)
      date = Date.yesterday.strftime(WEEKDAY_MONTH_DAY_YEAR)

      location.events << Event.create(date: date)
      visit "/"

      assert has_content?(next_board_game_night), error_didnt_find(next_board_game_night)

      assert has_content?(date), error_didnt_find(date)

      assert has_content?(location_name), error_didnt_find(location_name)
    end

    def test_location_when_date_is_today
      game_night_tonight = "Board game night is tonight"
      location_name = "today brewery"

      location = Location.create(name: location_name)
      date = Date.today.strftime(WEEKDAY_MONTH_DAY_YEAR)

      location.events << Event.create(date: date)
      visit "/"

      assert has_content?(game_night_tonight), error_didnt_find(game_night_tonight)

      assert has_content?(location_name), error_didnt_find(location_name)
    end

    def test_it_has_next_week
      location = Location.create(name: "Teen Titans GO!")

      this_week = Date.today.strftime(WEEKDAY_MONTH_DAY_YEAR)
      location.events << Event.create(date: this_week)

      next_week = Date.tomorrow.strftime(WEEKDAY_MONTH_DAY_YEAR)
      location.events << Event.create(date: next_week)

      visit "/next_week"

      assert has_content?(next_week), error_didnt_find(next_week)
    end

    def test_a_user_can_update_events
      location = Location.create(name: "Smallville")

      event_yesterday = Date.yesterday.strftime(WEEKDAY_MONTH_DAY_YEAR)
      location.events << Event.create(date: event_yesterday)

      event_tomorrow = Date.tomorrow.strftime(WEEKDAY_MONTH_DAY_YEAR)
      location.events << Event.create(date: event_tomorrow)

      visit "/"
      assert has_content?(event_yesterday), error_didnt_find(event_yesterday)

      visit "/update_events"

      assert has_content?(event_tomorrow), error_didnt_find(event_tomorrow)
    end

    private

      def error_didnt_find(date)
        "\nDidn't find '#{date}' in:
        #{"-"*20}
        #{body.match(/<body.+<\/body/m)[0]}
        #{"-"*20}"
      end

      def silence_stdout
        @original_stdout = $stdout
        $stdout = StringIO.new
      end

      def unsilence_stdout
        $stdout = @original_stdout
      end
  end
end
