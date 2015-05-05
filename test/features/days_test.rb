require "./test/test_helper"

module BoardGameNight
  class DaysTest < Minitest::Test
    include Capybara::DSL

    def test_it_shows_an_error_when_there_are_no_locations
      visit "/"

      expected = "Oops!"

      assert has_content?(expected), "Didn't find '#{expected}' in #{body}"
    end

    def test_a_location_when_date_is_before_today
      date = Date.yesterday.strftime("%A, %B %d %Y")
      location = "yesterday brewery"
      Location.create(date: date, name: location)

      visit "/"

      assert has_content?(date),
        "Didn't find '#{date}' in #{body}"

      assert has_content?(location),
        "Didn't find '#{location}' in #{body}"
    end

    def test_location_when_date_is_today
      location = "today brewery"
      Location.create(date: Date.today.strftime("%A, %B %d %Y"), name: location)

      visit "/"
      expected_message = "Board game night is tonight"

      assert has_content?(expected_message),
        "Didn't find '#{expected_message}' in #{body}"

      assert has_content?(location),
        "Didn't find '#{location}' in #{body}"
    end

    def teardown
      Location.destroy_all
    end
  end
end
