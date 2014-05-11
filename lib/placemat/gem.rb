require 'bundler'
require 'pathname'

class Placemat::Gem
  def initialize(gemspec_path)
    @path = Pathname.new(gemspec_path).expand_path
    @spec = Bundler.load_gemspec(gemspec_path)
  end

  attr_reader :path
  attr_reader :spec

  def name
    spec.name
  end

  def inspect
    "#<#{self.class} #{spec.full_name} #{path}>"
  end

  def to_s
    spec.full_name
  end
end
