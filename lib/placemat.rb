# `Placemat` API
# ==============
require 'pathname'
require 'placemat/autoload_convention'

# Dotum makes use of [autoloading](placemat/autoload_convention.html) to enforce
# consistency of file/constant naming, and to keep load times down.
#
# In order to use anything in Placemat, you just need to `require 'dotum'`.
module Placemat
  extend Placemat::AutoloadConvention

  GEM_PATH   = Pathname.new(File.expand_path('../..', __FILE__))
  LIB_PATH   = GEM_PATH.join('lib')
  TASKS_PATH = GEM_PATH.join('tasks')
  DATA_PATH  = GEM_PATH.join('data')
end
