module BoardGameNight
  class Event < ActiveRecord::Base
    belongs_to :location
    default_scope { order(:date) }

    def self.purge
      where("date < ?", Date.today).destroy_all
    end

    def name
      location.name
    end

    def address
      location.address
    end
  end
end
