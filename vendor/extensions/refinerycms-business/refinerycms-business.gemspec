# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-business'
  s.authors           = ['Daniel Viklund']
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Business extension for Refinery CMS'
  s.date              = '2014-09-22'
  s.summary           = 'Business extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '>= 2.1.2'
  s.add_dependency             'refinerycms-marketing'
  s.add_dependency             'refinerycms-page_roles',  '>= 1.0'
  s.add_dependency             'trans_forms'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 2.1.2'
  s.add_development_dependency 'pry'
end
