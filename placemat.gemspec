# Grab the version string, but don't pollute the global namespace so that
# dependents are not confused about a partially-loaded library.
version_path = File.expand_path('../lib/placemat/version.rb', __FILE__)
version_string = Module.new.tap do |anon_namespace|
  anon_namespace.module_eval(File.read(version_path), version_path)
end::Placemat::Version.to_s

Gem::Specification.new do |gem|
  gem.name     = 'placemat'
  gem.summary  = 'Placemat provides a complete development environment gems.'
  gem.authors  = ['Ian MacLeod']
  gem.email    = ['ian@nevir.net']
  gem.homepage = 'https://github.com/nevir/rb-placemat'
  gem.license  = 'MIT'

  gem.version  = version_string
  gem.platform = Gem::Platform::RUBY

  # TODO: Don't suck in Gemfile.lock, etc.
  gem.files         = Dir['{bin,data,lib,spec,tasks}/**/*', '*', '.gitignore']
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^spec\//)
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'bundler'
  gem.add_runtime_dependency 'byebug'
  gem.add_runtime_dependency 'git'
  gem.add_runtime_dependency 'guard'
  gem.add_runtime_dependency 'guard-bundler'
  gem.add_runtime_dependency 'guard-cucumber'
  gem.add_runtime_dependency 'guard-rspec'
  gem.add_runtime_dependency 'guard-rubocop'
  gem.add_runtime_dependency 'guard-spork'
  gem.add_runtime_dependency 'launchy'
  gem.add_runtime_dependency 'libnotify'
  gem.add_runtime_dependency 'mutant'
  gem.add_runtime_dependency 'mutant-rspec'
  gem.add_runtime_dependency 'pry'
  gem.add_runtime_dependency 'rake'
  gem.add_runtime_dependency 'rb-notifu'
  gem.add_runtime_dependency 'rspec'
  gem.add_runtime_dependency 'rubocop'
  gem.add_runtime_dependency 'rubocop-rspec'
  gem.add_runtime_dependency 'simplecov'
  gem.add_runtime_dependency 'terminal-notifier-guard'
  gem.add_runtime_dependency 'zeus'
end
