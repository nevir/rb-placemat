if defined? Placemat
  Placemat.reload!
else
  require 'placemat'
end

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
Placemat::Guard.install_rubocop_guard
