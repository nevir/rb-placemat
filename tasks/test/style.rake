require 'rubocop/rake_task'

namespace :test do

  desc 'Check the Dotum source for style violations and lint'
  RuboCop::RakeTask.new(:style) do |task|
    task.requires << 'rubocop-rspec'
  end

end
