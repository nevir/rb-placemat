require 'placemat'

watch(%r{^lib/placemat/guard.*\.rb$}) do
  Placemat.reload!
  ::Guard.evaluator.reevaluate_guardfile
end

# Normally, a call to `Placemat::Guard.install_guards` is sufficient, but you
# can also set up the guards individually, and provide additional watches:
Placemat::Guard.install_bundler_guard

Placemat::Guard.install_spork_guard do
  watch(%r{^lib/placemat/rspec.*\.rb$})
end

Placemat::Guard.install_rspec_guard
