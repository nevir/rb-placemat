require 'rspec'
require 'timeout'

# RSpec related behavior.
module Placemat::Rspec
  class << self
    def preload
      require 'rspec'
      require 'guard/rspec/formatter'

      load rspec_root.join('spec_helper.rb')
    end

    def default_configuration # rubocop:disable MethodLength
      configure_environment
      set_default_configuration
      load_shared_behavior
      # TODO(nevir): each_run.
      enable_coverage if ENV['COVERAGE']
    end

    def configure_environment
      rspec_root = Placemat::Project.current.rspec_root.to_s
      $LOAD_PATH << rspec_root unless $LOAD_PATH.include? rspec_root
    end

    def set_default_configuration # rubocop:disable MethodLength
      ::RSpec.configure do |config|
        # TODO(nevir): Only when not in guard!
        # config.add_formatter :documentation
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

    private

    def rspec_root
      Placemat::Project.current.rspec_root
    end
  end
end
