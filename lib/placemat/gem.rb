# `Gem`
# =====
require 'bundler'
require 'pathname'

# Metadata about a gem that this project builds.
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

  def lib_root
    path.dirname.join('lib', name)
  end

  def lib_files
    @lib_files ||= Dir.glob(lib_root.join('**', '*.rb'))
  end

  def root_namespace
    @root_namespace ||= begin
      flat_name = name.gsub('_', '').downcase
      matcher = /(?:module|class)\s+(#{flat_name})/i

      match = nil
      lib_files.each do |path|
        match = Placemat::Util.line_matching(path, matcher)
        break if match
      end

      fail "Couldn't detect gem namespace for #{name}!" unless match
      match[1]
    end
  end
end
