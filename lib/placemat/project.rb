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

  def spec_root
    @spec_root ||= @root.join('spec')
  end

  def lib_root
    @lib_root ||= @root.join('lib')
  end

  def preload_lib
    Dir.glob(lib_root.join('**', '*.rb')).each do |path|
      require Pathname.new(path).relative_path_from(lib_root).to_s[0...-3]
    end
  end

end
