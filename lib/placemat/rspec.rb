require 'rspec'
require 'timeout'

module Placemat::Rspec
  class << self

    def set_default_configuration
      ::RSpec.configure do |config|
        config.add_formatter :documentation
        config.color = true
        config.order = :random
        config.treat_symbols_as_metadata_keys_with_true_values = true

        # We enforce expect(...) style syntax to avoid mucking around in Core
        config.expect_with :rspec do |c|
          c.syntax = :expect
        end

        # Time out specs (particularly useful for mutant)
        config.around(:each) do |spec|
          timeout(0.5) { spec.run }
        end
      end
    end

  end
end
