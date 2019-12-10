# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-quality_assurance'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Quality Assurance extension for Refinery CMS'
  s.date              = '2019-04-12'
  s.summary           = 'Quality Assurance extension for Refinery CMS'
  s.authors           = 
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '>= 3.0.6'
  s.add_dependency             'refinerycms-business','~> 1.0.0'
  s.add_dependency             'refinerycms-resource_authorizations'
  s.add_dependency             'acts_as_indexed',     '~> 0.8.0'
  s.add_dependency             'jbuilder',            '2.9.0'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 3.0.6'
end
