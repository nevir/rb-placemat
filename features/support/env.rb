require 'placemat'
Placemat::Cucumber.default_configuration

Spork.prefork do

end

Spork.each_run do
  # Sadly, we cannot guarantee a clean environment when using Placemat to
  # bootstrap its own spec/spork configuration. Instead, we are careful to
  # unload everything prior to each test:
  Placemat.reload!
end
