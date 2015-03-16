require 'timeout'

# RSpec related behavior.
module Placemat::Rspec
  class << self
    def preload
      require 'rspec'
      Placemat::Simplecov.preload

      load spec_helper_path
    end

    def default_configuration # rubocop:disable MethodLength
      configure_environment
      set_default_configuration
      load_shared_behavior
      configure_coverage
      # TODO(nevir): each_run.
      enable_coverage if ENV['COVERAGE']
    end

    def configure_environment
      rspec_root = Placemat::Project.current.rspec_root.to_s
      $LOAD_PATH << rspec_root unless $LOAD_PATH.include? rspec_root
    end

    def set_default_configuration # rubocop:disable MethodLength
      ::RSpec.configure do |config|
        config.color = true
        config.order = :random

        # We enforce expect(...) style syntax to avoid mucking around in Core
        config.expect_with :rspec do |c|
          c.syntax = :expect
        end

        # Time out specs (particularly useful for mutant)
        #
        # TODO(nevir): NOT WHEN DEBUGGING.
        # config.around(:each) do |spec|
        #   timeout(0.5) { spec.run }
        # end
      end
    end

    def load_shared_behavior
      # Shuffle to ensure that we don't have weird dependency ordering.
      Dir.glob(rspec_root.join('shared', '**', '*.rb')).shuffle.each do |helper|
        require require "common/#{File.basename(helper, '.rb')}"
      end
    end

    def configure_coverage
      Placemat::Simplecov.default_configuration
    end

    def enable_coverage
      Placemat::Simplecov.start
      # Ensure accurate coverage by loading everything
      Placemat::Project.current.preload_lib
    end

    def enable_coveralls
      require 'coveralls'
      Coveralls.wear!
    end

    def rspec_root
      Placemat::Project.current.rspec_root
    end

    def spec_helper_path
      rspec_root.join('spec_helper.rb')
    end
  end
end
