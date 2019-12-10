# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-resource_authorizations'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Resource Authorizations extension for Refinery CMS'
  s.date              = '2019-05-27'
  s.summary           = 'Resource Authorizations extension for Refinery CMS'
  s.authors           = 
  s.require_paths     = %w(lib)
  s.files             = Dir["{db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',      '>= 3.0.6'
  s.add_dependency             'refinerycms-resources', '>= 3.0.6'
  s.add_dependency             'refinerycms-images',    '>= 3.0.6'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 3.0.6'
end
