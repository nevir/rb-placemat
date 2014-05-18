module Placemat::Spork
  class << self
    def load_or_shim
      require 'spork'
      require 'spork/ext/ruby-debug'
    rescue LoadError
      shim # No spork? No problem!
    end

    def shim
      spork = Module.new
      spork.module_eval do
        def self.prefork
          yield
        end
        def self.each_run
          yield
        end
      end
      ::Object.const_set(:Spork, spork)
    end
  end
end
