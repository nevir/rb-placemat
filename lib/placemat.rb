require 'pathname'
require 'placemat/autoload_convention'

module Placemat
  extend Placemat::AutoloadConvention

  GEM_PATH   = Pathname.new(File.expand_path('../..', __FILE__))
  LIB_PATH   = GEM_PATH.join('lib')
  TASKS_PATH = GEM_PATH.join('tasks')
  DATA_PATH  = GEM_PATH.join('data')
end
