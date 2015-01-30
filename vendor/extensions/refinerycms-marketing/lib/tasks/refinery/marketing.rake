namespace :refinery do

  namespace :marketing do

    # call this task by running: rake refinery:brands:my_task
    # desc "Description of my task below"
    # task :my_task => :environment do
    #   # add your logic here
    # end

    namespace :messenger do

      desc 'Start a messenger.'
      task :start => :environment_options do
        ::Refinery::Marketing::AmqpMessenger.new(@messenger_options).start
      end

      task :environment_options => :environment do
        @messenger_options = { }
      end

    end

  end

end
