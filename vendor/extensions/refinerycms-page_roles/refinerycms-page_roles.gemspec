# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.authors           = ['Daniel Viklund']
  s.name              = 'refinerycms-page_roles'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Page Roles extension for Refinery CMS'
  s.date              = '2015-06-26'
  s.summary           = 'Page Roles extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> 2.1.2'
  s.add_dependency             'refinerycms-pages',   '~> 2.1.2'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 2.1.2'
end
