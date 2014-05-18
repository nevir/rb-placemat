gem = Placemat::Rake.current_gem

namespace :test do

  desc 'Mutate the code base, checking the quality of test coverage'
  task :mutate, [:focus] do |task, task_args|
    require 'mutant'

    root_namespace = gem.root_namespace

    mutate_scope = task_args.focus || '*'
    mutate_scope = "::#{mutate_scope}" unless mutate_scope.start_with? '::'
    unless mutate_scope.start_with? "::#{gem.root_namespace}"
      mutate_scope = "::#{gem.root_namespace}#{mutate_scope}"
    end

    begin
      Mutant::CLI.run(['--use', 'rspec', mutate_scope])
    rescue NameError
      fail "Unable to find any symbols matching #{mutate_scope}"
    end
  end

end
