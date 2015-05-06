module BoardGameNight
  class Console < ActiveRecord::Base
    def self.run
      require "pry"; binding.pry
    end
  end
end
