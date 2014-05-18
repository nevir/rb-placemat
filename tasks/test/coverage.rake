namespace :test do

  desc 'Run all tests with code coverage'
  task :coverage do
    prev_coverage = ENV['COVERAGE']
    ENV['COVERAGE'] = 'yes'

    begin
      Rake::Task['test:all'].invoke
    rescue
      ENV['COVERAGE'] = prev_coverage
    end

    path = Placemat::Project.current.root.join('coverage', 'index.html')
    if path.exist?
      require 'launchy'
      Launchy.open(path.to_s)
    end
  end

end
