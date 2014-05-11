require 'placemat/rspec/init'

Spork.prefork do
  # Rubygems/Bundler will load <%= project_basename %>.gemspec, and by extension,
  # lib/<%= project_basename %>/version. Undo that for a clean test env.
  Object.send(:remove_const, :<%= project_namespace %>)

  # Preload any libraries that you use within the project.
end

Spork.each_run do
  # Customize how RSpec boots up your project for each test run.
end
