module Placemat
  # We adhere to a strict convention for the constants in this library:
  #
  # `Camel::Caps::BasedConstants` map to their underscore variants of
  # `camel/caps/based_constants`.
  #
  # Each autoloadable parent module/class only needs to to `extend` the
  # `AutoloadConvention` to bootstrap this behavior.
  module AutoloadConvention
    # `autoload` is dead, and we don't want to deal with its removal in 2.0,
    # so here's a thread-unsafe poor man's solution.
    def const_missing(sym)
      full_sym   = "#{name}::#{sym}"
      # Duplicates the logic from `Placemat::Util#underscore`, to avoid extra
      # dependencies.
      path_parts = full_sym.split('::').map do |part|
        part.gsub!(/([^A-Z])([A-Z]+)/,          '\\1_\\2') # OneTwo -> One_Two
        part.gsub!(/([A-Z]{2,})([A-Z][^A-Z]+)/, '\\1_\\2') # ABCOne -> ABC_One

        part.downcase
      end

      load "#{File.join(path_parts)}.rb"

      return super unless const_defined? sym
      autoloaded_constants << sym

      const_get(sym)
    end

    def autoloaded_constants
      @autoloaded_constants ||= []
    end

    def reload!
      autoloaded_constants.each { |s| remove_const(s) }
      @autoloaded_constants = []

      # Reload ourselves, as well.
      return unless self == ::Placemat
      load __FILE__
      extend ::Placemat::AutoloadConvention
    end
  end
end
