require 'rspec/core/rake_task'

gem = Placemat::Rake.current_gem

namespace :test do

  desc 'Run the unit tests'
  RSpec::Core::RakeTask.new(:unit, [:focus]) do |task, task_args|
    task.rspec_opts = [
      '--require', Placemat::Rspec.spec_helper_path,
      '--format', 'documentation'
    ]

    if task_args.focus
      focus_root = Placemat::Util.symbol_to_path(task_args.focus)

      if match = /^(.+)[\.\#](.+)$/.match(focus_root)
        focus_root = match[1]
        # The caller may wish to organize class vs instance methods in subdirs.
        focus_root += '{,/*}'
        focus_root += "/#{match[2]}"
      end

      unless focus_root.start_with? gem.name
        focus_root = "#{gem.name}/#{focus_root}"
      end

      task.pattern = "./spec/unit/#{focus_root}{,**/*}_spec.rb"
    end
  end

end
