begin
  require 'rspec/core/rake_task'

  desc "Run specs"
  RSpec::Core::RakeTask.new do |t|
    t.pattern = [
        'spec/**{,/*/**}/*_spec.rb',
        'vendor/extensions/refinerycms-*/spec/**{,/*/**}/*_spec.rb'
    ]

    t.verbose = false
  end

  task :spec

rescue LoadError => e
  # Unable to load rspec tasks, might occur in production
end
