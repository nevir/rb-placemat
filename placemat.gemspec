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

  gem.files         = Dir['{bin,data,lib,spec,tasks}/**/*', '*', '.gitignore']
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'bundler',                 '~> 1.6'
  gem.add_runtime_dependency 'debugger',                '~> 1.6'
  gem.add_runtime_dependency 'git',                     '~> 1.2'
  gem.add_runtime_dependency 'guard',                   '~> 2.6'
  gem.add_runtime_dependency 'guard-bundler',           '~> 2.0'
  gem.add_runtime_dependency 'guard-cucumber',          '~> 1.4'
  gem.add_runtime_dependency 'guard-rspec',             '~> 4.2'
  gem.add_runtime_dependency 'guard-spork',             '~> 1.5'
  gem.add_runtime_dependency 'launchy',                 '~> 2.4'
  gem.add_runtime_dependency 'libnotify',               '~> 0.8'
  gem.add_runtime_dependency 'pry',                     '~> 0.9'
  gem.add_runtime_dependency 'rake',                    '~> 10.3'
  gem.add_runtime_dependency 'rb-notifu',               '~> 0.0'
  gem.add_runtime_dependency 'rspec',                   '~> 2.14'
  gem.add_runtime_dependency 'simplecov',               '~> 0.8'
  gem.add_runtime_dependency 'terminal-notifier-guard', '~> 1.5'
end
