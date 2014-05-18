require 'placemat'
Placemat::Rspec.default_configuration

Spork.prefork do
  # Less typing.
  module ::Fixtures; end
end

Spork.each_run do
  # Sadly, we cannot guarantee a clean environment when using Placemat to
  # bootstrap its own spec/spork configuration. Instead, we are careful to
  # unload everything prior to each test:
  Placemat.reload!
end
