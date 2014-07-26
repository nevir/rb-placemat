require 'forwardable'
require 'shellwords'
require 'socket'

# Guard related behavior.
#
# TODO: Toggle rspec/cucumber/etc when test dirs are added/removed.
module Placemat::Guard
  class << self
    extend Forwardable

    def_delegators :dsl, :guard, :watch

    # Guards installed by default, and their order.
    DEFAULT_GUARDS = [
      :bundler,
      :zeus_server,
      :rspec,
      :rubocop
    ]

    def dsl
      @dsl ||= begin
        require 'guard/dsl'
        ::Guard::Dsl.new
      end
    end

    def project
      Placemat::Project.current
    end

    def guardfile_path
      project_guardfile_path = project.root.join('Guardfile')
      if project_guardfile_path.exist?
        project_guardfile_path
      else
        Placemat::CONFIG_PATH.join('Guardfile').to_s
      end
    end

    def default_configuration(&block)
      config = Placemat::Util::DSLConfigurator.new(&block)
      DEFAULT_GUARDS.each do |guard|
        install_sym = :"install_#{guard}_guard"
        fail "Unknown guard #{guard}" unless respond_to? install_sym
        next if config[guard] == :skip

        send(install_sym, &config[guard])
      end
    end

    def install_bundler_guard(&block)
      guard :bundler do
        watch(/^Gemfile(\..+)?$/)
        watch(/^.+\.gemspec$/)

        instance_eval(&block) if block
      end
    end

    def zeus_server_options
      {
        start_cmd: Placemat::Zeus.cmd_base + ['start']
      }
    end

    def install_zeus_server_guard(&block)
      # Make sure that Zeus' boot command has access to the correct copy of
      # Placemat.
      ENV['RUBYLIB'] = "#{Placemat::LIB_PATH}:#{ENV['RUBYLIB']}"

      guard :zeus_server, zeus_server_options do
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

    def rspec_options
      {
        cmd: "#{Shellwords.join(Placemat::Zeus.cmd_base)} rspec",
        all_on_start: true
      }
    end

    def specs_for_path(path)
      [
        "spec/unit/#{path}_spec.rb",
        Dir["spec/unit/#{path}/**/*_spec.rb"]
      ].flatten.uniq
    end

    def install_cucumber_guard(&block)
      guard :cucumber, cucumber_options do
        watch(/^features\/.+\.feature$/)
        watch(%r{^features/support/.+$})                      { 'features' }
        watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { 'features' }

        instance_eval(&block) if block
      end
    end

    def cucumber_port
      @cucumber_port ||= Placemat::Util.free_port
    end

    def cucumber_options
      {
        all_on_start: true
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
      cmd_base = Placemat::Zeus.cmd_base + ['rubocop']
      {
        all_on_start: true,
        cmd: cmd_base + Placemat::Rubocop.runner_options
      }
    end
  end
end
