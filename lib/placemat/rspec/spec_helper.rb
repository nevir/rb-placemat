begin
  require 'spork'
  require 'spork/ext/ruby-debug'
rescue LoadError
  # No spork? No problem!
  module Spork
    def self.prefork
      yield
    end

    def self.each_run
      yield
    end
  end
end

Spork.prefork do
  # Allow requires relative to the spec dir
  unless defined? PROJECT_ROOT
    PROJECT_ROOT = File.expand_path('../../../..', __FILE__)
  end
  LIB_ROOT     = File.join(PROJECT_ROOT, 'lib')
  SPEC_ROOT    = File.join(PROJECT_ROOT, 'spec')
  FIXTURE_ROOT = File.join(SPEC_ROOT, 'fixtures')
  $LOAD_PATH << SPEC_ROOT

  require 'rspec'
  require 'timeout'

  # Namespace to throw fixtures under, as desired.
  module Fixtures; end

  # Load our spec environment (random to avoid dependency ordering)
  Dir[File.join(SPEC_ROOT, 'common', '*.rb')].shuffle.each do |helper|
    require "common/#{File.basename(helper, ".rb")}"
  end

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true

    # We enforce expect(...) style syntax to avoid mucking around in Core
    config.expect_with :rspec do |c|
      c.syntax = :expect
    end

    # Time out specs (particularly useful for mutant)
    # config.around(:each) do |spec|
    #   timeout(0.5) { spec.run }
    # end
  end
end

Spork.each_run do
  # The rspec test runner executes the specs in a separate process; plus it's
  # nice to have this generic flag for cases where you want coverage running
  # with guard.
  if ENV['COVERAGE']
    require 'simplecov'

    if ENV['CONTINUOUS_INTEGRATION']
      require 'coveralls'
      Coveralls.wear!
    end
  end

  # Because we're an autoloading lib, just require the root up front.
  #
  # Must be loaded _after_ `simplecov`, otherwise it won't pick up on requires.
  require 'placemat'

  # Ensure accurate coverage by loading everything if we're going to be doing a
  # full run.
  if ENV['PRELOAD_ALL']
    require 'pathname'

    lib_root = Pathname.new(PROJECT_ROOT).join('lib')
    Dir["#{lib_root}/**/*.rb"].each do |file|
      require Pathname.new(file).relative_path_from(lib_root).to_s[0...-3]
    end
  end
end
