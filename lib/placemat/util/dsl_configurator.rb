# A Hash-like object that allows for basic DSL-like configuration.
class Placemat::Util::DSLConfigurator < Hash
  def initialize(&block)
    instance_exec(self, &block) if block
  end

  # You can assign values by calling methods on the configurator:
  #
  #   config.some_value :ohai
  #
  # You may also assign them via a traditional assignment:
  #
  #   config.some_value = :ohai
  #
  # Or you may use hash syntax:
  #
  #   config[:some_value] = :ohai
  #
  # Finally, calling a method without arguments will return its value:
  #
  #   config.some_value == :ohai
  #
  def method_missing(key, *args, &block)
    key = key[0...-1].to_sym if key.to_s.end_with? '='

    if block
      self[key] = block
    elsif args.size == 1
      self[key] = args.first
    elsif args.size > 1
      self[key] = args
    end

    self[key]
  end
end
