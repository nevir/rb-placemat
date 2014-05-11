# Because the Guardfile can be reloaded; we cannot require it. For normal
# Placemat users, a `require 'placemat/guard/init'` is just fine.
load File.expand_path('../lib/placemat/guard/init.rb', __FILE__)

def reload_placemat!
  # Note that we seem to have dangling references left; but they get cleared
  # the *next* time, and the guard configuration properly reloads. So not a
  # leak, but a little hard to reason about.
  ::Object.send(:remove_const, :Placemat) if defined? ::Placemat

  # We require Placemat everywhere else, and don't want to mess with that; so we
  # have to forcefully reload Placemat's core here.
  load File.expand_path("../lib/placemat/autoload_convention.rb", __FILE__)
  load File.expand_path("../lib/placemat.rb", __FILE__)
end

watch("Guardfile") do
  reload_placemat!
end

watch(%r{^lib/placemat/guard.*$}) do
  # TODO: unload all of placemat!
  reload_placemat!
  ::Guard.evaluator.reevaluate_guardfile
end
