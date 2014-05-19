module Placemat
  # Version information for Placemat.
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 1

    # Placemat's version number as a string.
    def self.to_s
      "#{MAJOR}.#{MINOR}.#{PATCH}"
    end
  end
end
