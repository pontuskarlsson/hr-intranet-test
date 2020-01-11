# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-shipping'
  s.version           = '1.0'
  s.authors           = ['Daniel Viklund']
  s.description       = 'Ruby on Rails Shipping extension for Refinery CMS'
  s.date              = '2014-09-25'
  s.summary           = 'Shipping extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-business'
  s.add_dependency             'refinerycms-core',      '>= 2.1.2'
  s.add_dependency             'refinerycms-marketing'
  s.add_dependency             'refinerycms-page_roles',  '>= 1.0'
  s.add_dependency             'jbuilder',            '2.9.0'
  s.add_dependency             'trans_forms'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 2.1.2'
end
