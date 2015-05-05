module BoardGameNight
  class Location < ActiveRecord::Base
    before_save :strip_name

    def strip_name
      self.name.strip!
    end
  end
end
