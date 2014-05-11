require 'placemat'

load Placemat::LIB_PATH.join('placemat', 'rspec', 'spec_helper.rb')

RSpec.configure do |config|
  config.add_formatter :documentation
  config.color = true
  config.order = :random
end
