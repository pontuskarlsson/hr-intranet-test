namespace :messenger do

  desc 'Start a messenger.'
  task :start => :environment_options do
    AmqpMessenger.new(@messenger_options).start
  end

  task :environment_options => :environment do
    @messenger_options = { }
  end

  desc "Exit with error status if any jobs older than max_age seconds haven't been attempted yet."
  task :check, [:max_age] => :environment do |_, args|
    args.with_defaults(:max_age => 300)

    unprocessed_jobs = Delayed::Job.where('attempts = 0 AND created_at < ?', Time.now - args[:max_age].to_i).count

    if unprocessed_jobs > 0
      raise "#{unprocessed_jobs} jobs older than #{args[:max_age]} seconds have not been processed yet"
    end

  end

end