Spork.prefork do
  # Allow requires relative to the spec dir
  unless defined? PROJECT_ROOT
    PROJECT_ROOT = File.expand_path('../../../..', __FILE__)
  end
  LIB_ROOT     = File.join(PROJECT_ROOT, 'lib')
  SPEC_ROOT    = File.join(PROJECT_ROOT, 'spec')
  FIXTURE_ROOT = File.join(SPEC_ROOT, 'fixtures')
  $LOAD_PATH << SPEC_ROOT

  # Namespace to throw fixtures under, as desired.
  module Fixtures; end

  # Load our spec environment (random to avoid dependency ordering)
  Dir[File.join(SPEC_ROOT, 'common', '*.rb')].shuffle.each do |helper|
    require "common/#{File.basename(helper, ".rb")}"
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
