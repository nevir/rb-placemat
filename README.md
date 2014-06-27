Placemat
========

Tired of spending hours configuring every new gem you write? Yeah, me too.

Placemat takes all of that common configuration, and manages most of it for
you. It also takes care of keeping your projects up to date with the latest
development practices - Placemat is _not_ a project generator!


Getting Started
---------------

You can scaffold out a new project via

    placemat PROJECT_DIR

Or you can scaffold an existing project with the same command by pointing it to
your existing directory.


What You Get
------------

### Guard-Driven Development

A good development environment is one that reduces the latency between edits
and feedback of their quality.

Placemat sets up [Guard](https://github.com/guard/guard) to watch _everything_
related to your project. To develop against a Placemat-enabled project, your
flow should be:

1. Run `guard`.
2. Write code.

That's it. Guard will watch your changes, run the appropriate tests, linters,
etc.


### Unit Testing

Placemat sets you up with RSpec. It'll proably support Cucumber in the future,
too.


### Mutation Testing

Placemat sets up mutation testing for your unit tests.

**This does not run under guard** (too slow).


### Style Linting

Placemat configures your project to use RuboCop.


### Debugging

Placemat sets up byebug for you.


License
-------

Placemat is [MIT licensed](MIT-LICENSE.md).
