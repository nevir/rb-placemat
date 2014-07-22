if defined? Placemat
  Placemat.reload!
else
  require 'placemat'
end
Placemat::Guard.default_configuration do
  zeus do
    watch('zeus.json')
    watch(%r{^lib/placemat/zeus.*\.rb$})
  end
end

watch(%r{^lib(/placemat)?/guard.*\.rb$}) do
  ::Guard.evaluator.reevaluate_guardfile
end
