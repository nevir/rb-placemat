require 'placemat'

Placemat::Spork.load_or_shim

# load Placemat::LIB_PATH.join('placemat', 'rspec', 'spec_helper.rb')

Spork.prefork do
  Placemat::Rspec.set_default_configuration
end

Spork.each_run do

end
