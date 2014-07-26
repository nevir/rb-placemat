require 'zeus'

module Placemat
  module Zeus
    # A Zeus plan to handle Placemat-enabled projects.
    class Plan < ::Zeus::Plan
      def boot
        require 'bundler/setup'
        require 'placemat'
      end

      def preload_rspec
        Placemat::Rspec.preload
      end

      def rspec(argv = ARGV)
        RSpec.configuration.start_time = Time.now
        exit ::RSpec::Core::Runner.run(argv)
      end

      def preload_rubocop
        Placemat::Rubocop.preload
      end

      def rubocop(argv = ARGV)
        Rainbow.enabled = true
        exit ::RuboCop::CLI.new.run(argv)
      end

      ::Zeus.plan = new
    end
  end
end
