# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-employees'
  s.version           = '1.0'
  s.authors           = ['Daniel Viklund']
  s.description       = 'Ruby on Rails Employees extension for Refinery CMS'
  s.date              = '2014-09-29'
  s.summary           = 'Employees extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',            '>= 2.1.2'
  s.add_dependency             'refinerycms-authentication-devise',  '1.0.4'
  s.add_dependency             'refinerycms-calendar',        '>= 2.1'
  s.add_dependency             'xeroizer'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 2.1.2'
end
