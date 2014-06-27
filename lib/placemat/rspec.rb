require 'rspec'
require 'timeout'

# RSpec related behavior.
module Placemat::Rspec
  class << self
    def default_configuration # rubocop:disable MethodLength
      # TODO(nevir): prefork.
      Placemat::Rspec.configure_environment
      Placemat::Rspec.set_default_configuration
      Placemat::Rspec.load_shared_behavior

      # TODO(nevir): each_run.
      Placemat::Rspec.enable_coverage if ENV['COVERAGE']
    end

    def configure_environment
      rspec_root = Placemat::Project.current.rspec_root.to_s
      $LOAD_PATH << rspec_root unless $LOAD_PATH.include? rspec_root
    end

    def set_default_configuration # rubocop:disable MethodLength
      ::RSpec.configure do |config|
        config.add_formatter :documentation
        config.color = true
        config.order = :random

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

    def load_shared_behavior
      configure_environment

      rspec_root = Placemat::Project.current.rspec_root
      # Shuffle to ensure that we don't have weird dependency ordering.
      Dir.glob(rspec_root.join('shared', '**', '*.rb')).shuffle.each do |helper|
        require require "common/#{File.basename(helper, '.rb')}"
      end
    end

    def enable_coverage
      require 'simplecov'
      SimpleCov.start

      # Ensure accurate coverage by loading everything
      Placemat::Project.current.preload_lib
    end

    def enable_coveralls
      require 'coveralls'
      Coveralls.wear!
    end
  end
end
