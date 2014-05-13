# Ideally, we wouldn't need to run bundler/setup until after rake begins
# execution (for quick help); but it's a real pain (rspec & other externally
# loaded tasks).
require 'bundler/setup'
require 'placemat'

gems = ::Placemat::Project.current.gems
if gems.size == 1
  ::Placemat::Rake.install_tasks(gems.first)
else
  gems.each do |gem|
    namespace gem.name do
      ::Placemat::Rake.install_tasks(gem)
    end
  end
end
