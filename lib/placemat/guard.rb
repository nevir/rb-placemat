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

    def project
      Placemat::Project.current
    end

    def default_configuration # rubocop:disable MethodLength
      # TODO: Toggle rspec/spork/etc when test dirs are added/removed.
      install_bundler_guard
      install_spork_guard  # spring or zeus
      install_rspec_guard
      install_cucumber_guard
      install_rubocop_guard
    end

    def install_bundler_guard(&block)
      guard :bundler do
        watch(/^Gemfile(\..+)?$/)
        watch(/^.+\.gemspec$/)

        instance_eval(&block) if block
      end
    end

    def install_spork_guard(&block)
      return unless project.rspec? || project.cucumber?

      guard :spork, rspec_port: rspec_port do
        watch('Gemfile')
        watch('Gemfile.lock')
        watch('.rspec')
        watch(/^spec\/.*_helper\.rb$/)
        watch(%r{^spec/common/.*\.rb$})

        instance_eval(&block) if block
      end
    end

    def install_rspec_guard(&block)
      return unless project.rspec?

      guard :rspec, rspec_options do
        watch(/^spec\/.*_spec\.rb$/)
        watch(/^lib\/(.+)\.rb$/) { |m| specs_for_path(m[1]) }

        instance_eval(&block) if block
      end
    end

    def rspec_port
      @rspec_port ||= Placemat::Util.free_port
    end

    def rspec_options
      {
        all_on_start: true,
        cmd: "rspec --drb --drb-port #{rspec_port}"
      }
    end

    def specs_for_path(path)
      [
        "spec/unit/#{path}_spec.rb",
        Dir["spec/unit/#{path}/**/*_spec.rb"]
      ].flatten
    end

    def install_cucumber_guard(&block)
      guard :cucumber, cucumber_options do
        watch(%r{^features/.+\.feature$})
        watch(%r{^features/support/.+$})                      { 'features' }
        watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { 'features' }
      end
    end

    def cucumber_port
      @cucumber_port ||= Placemat::Util.free_port
    end

    def cucumber_options
      {
        all_on_start: true,
        cli: "--drb --port #{cucumber_port}"
      }
    end

    def install_rubocop_guard(&block)
      guard :rubocop, rubocop_options do
        watch('.rubocop.yml') { '.' }

        watch(/.+\.(rb|rake|gemspec)$/)
        watch('Rakefile')
        watch('Gemfile')
        watch('Guardfile')

        instance_eval(&block) if block
      end
    end

    def rubocop_options
      {
        all_on_start: true,
        cli: %w(--format clang --require rubocop-rspec)
      }
    end
  end
end
