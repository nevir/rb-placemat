# Metadata about a Placemat-managed project.
#
# Note that some projects define multiple gems (for instance, Rails) within the
# same repo.
class Placemat::Project
  def self.current
    @current ||= new(Dir.pwd)
  end

  def initialize(root)
    @root = Pathname.new(root).expand_path
  end

  attr_reader :root

  def env
    (ENV['ENV'] || :development).to_sym
  end

  def gems
    @gems ||= Dir.glob(root.join('*.gemspec')).map do |path|
      Placemat::Gem.new(path)
    end
  end

  def rspec_root
    @rspec_root ||= @root.join('spec')
  end

  def rspec?
    rspec_root.join('spec_helper.rb').exist?
  end

  def cucumber_root
    @cucumber_root ||= @root.join('features')
  end

  def cucumber?
    cucumber_root.join('support', 'env.rb').exist?
  end

  def lib_root
    @lib_root ||= @root.join('lib')
  end

  def lib_files
    @lib_files ||= gems.map(&:lib_files).flatten
  end

  def preload_dependencies(*environments)
    environments << env if environments.size == 0

    require 'bundler/setup'
    Bundler.require(:default, *Array(environments))
  end

  def preload_lib
    lib_files.each do |path|
      require Pathname.new(path).relative_path_from(lib_root).to_s[0...-3]
    end
  end
end
