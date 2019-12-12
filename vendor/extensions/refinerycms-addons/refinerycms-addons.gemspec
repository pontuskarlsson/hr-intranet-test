# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-addons'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Addons extension for Refinery CMS'
  s.date              = '2019-11-08'
  s.summary           = 'Addons extension for Refinery CMS'
  s.authors           = 'Daniel Viklund'
  s.require_paths     = %w(lib)
  s.files             = Dir["{db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',      '>= 3.0.6'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '>= 3.0.6'
end
