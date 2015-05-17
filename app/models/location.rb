module BoardGameNight
  class Location < ActiveRecord::Base
    has_many :events

    before_save :strip_name

    def strip_name
      self.name.strip!
    end
  end
end
