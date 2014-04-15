$:.push File.expand_path("../lib", __FILE__)
require "shibbolite/version"

Gem::Specification.new do |s|
  s.name        = "shibbolite"
  s.version     = Shibbolite::VERSION
  s.authors     = ["David Bassett"]
  s.email       = ["dabassett.github@gmail.com"]
  s.homepage    = "https://github.com/dabassett/shibbolite"
  s.summary     = "Simple access control for Shibboleth/Rails environments"
  s.description = "Simple access control for Shibboleth/Rails environments"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'factory_girl_rails', '~> 4.4'
  s.add_development_dependency 'guard-rspec', '~> 4.2'
  s.add_development_dependency 'fuubar', '~> 1.3'
  s.add_development_dependency 'database_cleaner', '~> 1.2'
end
