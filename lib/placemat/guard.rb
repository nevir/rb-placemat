require 'forwardable'

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

    def install_guards
      install_bundler_guard
      install_spork_guard
      install_rspec_guard
    end

    def install_bundler_guard
      guard :bundler do
        watch(%r{^Gemfile(\..+)?$})
        watch(%r{^.+\.gemspec$})
      end
    end

    def install_spork_guard
      guard :spork, :rspec_port => 2727 do
        watch('Gemfile')
        watch('Gemfile.lock')
        watch('.rspec')
        watch(%r{^spec/.*_helper\.rb$})
        watch(%r{^spec/common/.*\.rb$})
      end
    end

    def install_rspec_guard
      guard :rspec, :cmd => 'rspec --drb --drb-port 2727' do
        watch(%r{^lib/(.+)\.rb$}) { |m| specs_for_path(m[1]); }
      end
    end

    def specs_for_path(path)
      [
        "spec/unit/#{path}_spec.rb",
        Dir["spec/unit/#{path}/**/*_spec.rb"]
      ].flatten.tap { |s| puts s.inspect }
    end

  end
end
