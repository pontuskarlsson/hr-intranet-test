# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-parcels'
  s.version           = '1.0'
  s.authors           = ['Daniel Viklund']
  s.description       = 'Ruby on Rails Parcels extension for Refinery CMS'
  s.date              = '2014-09-25'
  s.summary           = 'Parcels extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',      '~> 2.1.2'
  s.add_dependency             'refinerycms-contacts',  '~> 1.0'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 2.1.2'
end
