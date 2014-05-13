require 'placemat'

class Placemat::Project

  def self.current
    @current ||= new(Dir.pwd)
  end

  def initialize(root)
    @root = Pathname.new(root).expand_path
  end

  attr_reader :root

  def gems
    @gems ||= Dir.glob(root.join('*.gemspec')).map do |path|
      Placemat::Gem.new(path)
    end
  end

end
