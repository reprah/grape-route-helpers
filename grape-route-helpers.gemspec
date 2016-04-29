require File.join(Dir.pwd, 'lib', 'grape-route-helpers', 'version')

Gem::Specification.new do |gem|
  gem.name        = 'grape-route-helpers'
  gem.version     = GrapeRouteHelpers::VERSION
  gem.licenses    = ['MIT']
  gem.summary     = 'Route helpers for Grape'
  gem.description = 'Route helpers for Grape'
  gem.authors     = ['Harper Henn']
  gem.email       = 'harper.henn@legitscript.com'
  gem.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.homepage    = 'https://github.com/reprah/grape-route-helpers'

  gem.add_runtime_dependency 'grape', '~> 0.16', '>= 0.16.0'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'rake'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
end
