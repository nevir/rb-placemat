require 'placemat'

# Rake changes the working directory to the Rakefile's directory.
gems = Dir['*.gemspec'].map { |p| Placemat::Gem.new(p) }

if gems.size == 1
  Placemat::Rake.install_tasks(gems.first)
else
  gems.each do |gem|
    namespace gem.name do
      Placemat::Rake.install_tasks(gem)
    end
  end
end
