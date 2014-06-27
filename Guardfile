if defined? Placemat
  Placemat.reload!
else
  require 'placemat'
end
Placemat::Guard.default_configuration

watch(%r{^lib/placemat/guard.*\.rb$}) do
  ::Guard.evaluator.reevaluate_guardfile
end
