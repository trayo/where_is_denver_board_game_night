require "./test/test_helper"

module BoardGameNight
  class DaysTest < Minitest::Test
    include Capybara::DSL

    def teardown
      Location.destroy_all
      Event.destroy_all
    end

    def test_it_shows_an_error_when_there_are_no_locations
      visit "/"

      expected = "Oops!"

      assert has_content?(expected), "Didn't find '#{expected}' in #{body}"
    end

    def test_a_location_when_date_is_before_today
      expected_message = "The next board game night is"
      location_name = "yesterday brewery"
      date = Date.yesterday.strftime("%A, %B %d %Y")

      location = Location.create(name: location_name)
      location.events << Event.create(date: date)
      visit "/"

      assert has_content?(expected_message),
        "Didn't find '#{expected_message}' in #{body}"

      assert has_content?(date),
        "Didn't find '#{date}' in #{body}"

      assert has_content?(location_name),
        "Didn't find '#{location_name}' in #{body}"
    end

    def test_location_when_date_is_today
      location_name = "today brewery"
      date = Date.today.strftime("%A, %B %d %Y")
      expected_message = "Board game night is tonight"

      location = Location.create(name: location_name)
      location.events << Event.create(date: date)

      visit "/"

      assert has_content?(expected_message),
        "Didn't find '#{expected_message}' in #{body}"

      assert has_content?(location_name),
        "Didn't find '#{location_name}' in #{body}"
    end
  end
end
