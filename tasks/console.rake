gem = Placemat::Rake.current_gem

desc "Boot up a console w/ #{gem.spec.name} preloaded"
task :console do |_task|
  # We follow the same logic as Bundler.require():
  # https://github.com/bundler/bundler/blob/95370a5c3eb96fee75dfb7852724b31cbf3e95e0/lib/bundler/runtime.rb#L69-77
  Array(gem.spec.autorequire || gem.spec.name).each do |path|
    require path
  end

  require 'pry'
  Pry.start
end
