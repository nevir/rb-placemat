require 'forwardable'
require 'socket'

# Guard related behavior.
module Placemat::Guard
  class << self
    extend Forwardable

    def_delegators :dsl, :guard, :watch

    def dsl
      @dsl ||= begin
        require 'guard/dsl'
        ::Guard::Dsl.new
      end
    end

    def default_configuration # rubocop:disable MethodLength
      install_bundler_guard
      install_spork_guard
      install_rspec_guard
    end

    def install_bundler_guard(&block)
      guard :bundler do
        watch(/^Gemfile(\..+)?$/)
        watch(/^.+\.gemspec$/)

        instance_eval(&block) if block
      end
    end

    def install_spork_guard(&block)
      guard :spork, rspec_port: spork_port do
        watch('Gemfile')
        watch('Gemfile.lock')
        watch('.rspec')
        watch(/^spec\/.*_helper\.rb$/)
        watch(%r{^spec/common/.*\.rb$})

        instance_eval(&block) if block
      end
    end

    def install_rspec_guard(&block)
      guard :rspec, rspec_options do
        watch(/^spec\/.*_spec\.rb$/)
        watch(/^lib\/(.+)\.rb$/) { |m| specs_for_path(m[1]) }

        instance_eval(&block) if block
      end
    end

    def rspec_options
      {
        all_on_start: true,
        cmd: "rspec --drb --drb-port #{spork_port}"
      }
    end

    def specs_for_path(path)
      [
        "spec/unit/#{path}_spec.rb",
        Dir["spec/unit/#{path}/**/*_spec.rb"]
      ].flatten
    end

    def spork_port
      @spork_port ||= begin
        socket = Socket.new(:INET, :STREAM, 0)
        socket.bind(Addrinfo.tcp('127.0.0.1', 0))
        port = socket.local_address.ip_port
        socket.close

        port
      end
    end
  end
end
