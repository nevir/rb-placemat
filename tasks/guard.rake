desc 'Watch for and test all changes to the project'
task :guard do
  require 'guard/cli'
  puts Placemat::Guard.guardfile_path
  Guard::CLI.start([
    '--guardfile', Placemat::Guard.guardfile_path
  ])
end
