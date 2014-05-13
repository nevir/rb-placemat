require 'placemat/rspec/init'

Spork.prefork do
  # We have an awkward situation, as Placemat bootstraps itself, but we want a
  # clean environment for tests.
  Object.send(:remove_const, :Placemat)
end

Spork.each_run do
  # Because Placemat has been previously required, we've gotta force the issue.
  lib_path = File.expand_path('../../lib', __FILE__)
  load File.join(lib_path, 'placemat', 'autoload_convention.rb')
  load File.join(lib_path, 'placemat.rb')
end
