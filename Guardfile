if defined? Placemat
  Placemat.reload!
else
  require 'placemat'
end

watch(%r{^lib/placemat/guard.*\.rb$}) do
  ::Guard.evaluator.reevaluate_guardfile
end

Placemat::Guard.default_configuration
