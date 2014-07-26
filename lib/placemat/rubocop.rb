# RuboCop related behavior.
module Placemat::Rubocop
  class << self
    def preload
      require 'rubocop'
      require 'rubocop-rspec'
    end

    def runner_options
      [
        '--require', 'rubocop-rspec',
        '--display-cop-names'
      ]
    end
  end
end
