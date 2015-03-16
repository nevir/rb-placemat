desc 'Watch for and test all changes to the project'
task :guard do
  # Swap out to the main `guard` executable, as it's the guy who's responsible
  # for reloading guard when a `Guardfile` changes (no public API for this).
  require 'rubygems'
  exec Gem.bin_path('guard', 'guard')
end
