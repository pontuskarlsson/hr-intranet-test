# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.authors           = ['Daniel Viklund']
  s.name              = 'refinerycms-custom_lists'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Custom Lists extension for Refinery CMS'
  s.date              = '2015-01-16'
  s.summary           = 'Custom Lists extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '>= 2.1.2'
  s.add_dependency             'refinerycms-page_roles',  '>= 1.0'
  s.add_dependency             'trans_forms'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 2.1.2'
end
