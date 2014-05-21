require 'cucumber'

module Placemat::Cucumber
  class << self
    def default_configuration # rubocop:disable MethodLength
      Placemat::Spork.load_or_shim
    end
  end
end
