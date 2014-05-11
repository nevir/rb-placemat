module Placemat::Rake
  # A hack to make gems available to task files during load.
  class << self
    attr_accessor :current_gem
  end

  def self.install_tasks(gem)
    install_bundler_tasks(gem)
    install_placemat_tasks(gem)

    self
  end

  def self.install_bundler_tasks(gem)
    require 'bundler/gem_helper'
    Bundler::GemHelper.install_tasks(
      :dir => gem.path.dirname, :name => gem.name
    )
  end

  def self.install_placemat_tasks(gem)
    Dir["#{Placemat::TASKS_PATH}/**/*.rake"].each do |task_path|
      self.current_gem = gem
      ::Kernel.load(task_path)
      self.current_gem = nil
    end
  end
end
