module BoardGameNight
  class Event < ActiveRecord::Base
    belongs_to :location
    default_scope { order(:date) }

    def name
      location.name
    end

    def address
      location.address
    end
  end
end
