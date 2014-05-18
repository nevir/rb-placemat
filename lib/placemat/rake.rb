module Placemat::Rake
  class << self
    # A hack to make gems available to task files during load.
    attr_accessor :current_gem

    def default_configuration
      # Ideally, we wouldn't need to run bundler/setup until after rake begins
      # execution (for quick help); but it's a real pain (due to rspec & other
      # externally loaded tasks).
      require 'bundler/setup'

      gems = Placemat::Project.current.gems
      if gems.size == 1
        Placemat::Rake.install_tasks(gems.first)
      else
        gems.each do |gem|
          namespace gem.name do
            Placemat::Rake.install_tasks(gem)
          end
        end
      end
    end

    def install_tasks(gem)
      install_bundler_tasks(gem)
      install_placemat_tasks(gem)

      self
    end

    def install_bundler_tasks(gem)
      require 'bundler/gem_helper'
      Bundler::GemHelper.install_tasks(
        :dir => gem.path.dirname, :name => gem.name
      )
    end

    def install_placemat_tasks(gem)
      Dir["#{Placemat::TASKS_PATH}/**/*.rake"].each do |task_path|
        self.current_gem = gem
        ::Kernel.load(task_path)
        self.current_gem = nil
      end
    end
  end
end
