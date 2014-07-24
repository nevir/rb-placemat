# Zeus related behavior.
module Placemat::Zeus
  extend Placemat::AutoloadConvention
  class << self
    def cmd_base
      ['zeus', '--config', Placemat::CONFIG_PATH.join('zeus.json').to_s]
    end
  end
end
