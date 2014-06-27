require 'placemat'
Placemat::Rspec.default_configuration

# TODO(nevir): prefork
module ::Fixtures; end

# TODO(nevir): each_run
# Sadly, we cannot guarantee a clean environment when using Placemat to
# bootstrap its own spec/spork configuration. Instead, we are careful to
# unload everything prior to each test:
Placemat.reload!
