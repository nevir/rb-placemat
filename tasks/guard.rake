desc 'Watch for and test all changes to the project'
task :guard do
  require 'guard/cli'
  Guard::CLI.start([])
end
