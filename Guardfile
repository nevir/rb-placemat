# Because we bootstrap ourselves, we have to be careful to not (auto)require
# placemat. Thus, we fake that environment.
#
# For normal Placemat users, a `require 'placemat/guard/init'` is just fine.
module ::Placemat; end
load File.expand_path('../lib/placemat/guard.rb', __FILE__)

watch(%r{^lib/placemat/guard.*\.rb$}) do
  ::Guard.evaluator.reevaluate_guardfile
end

# Normally, a call to `Placemat::Guard.install_guards` is sufficient, but you
# can also set up the guards individually, and provide additional watches:
Placemat::Guard.install_bundler_guard

Placemat::Guard.install_spork_guard do
  watch(%r{^lib/placemat/rspec.*\.rb$})
end

Placemat::Guard.install_rspec_guard

# Clean up our bootstrapping.
::Object.send(:remove_const, :Placemat)
