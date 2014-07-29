# SimpleCov related behavior.
module Placemat::Simplecov
  class << self
    def preload
      require 'simplecov'
    end

    def default_configuration
      require 'simplecov'
      ::SimpleCov.configure do
        add_filter '/spec/'
        add_filter '/data/'
      end
    end

    def start
      ::SimpleCov.start
    end
  end
end
