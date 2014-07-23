# RuboCop related behavior.
module Placemat::Rubocop
  class << self
    def preload
      require 'rubocop'
    end
  end
end
