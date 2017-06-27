namespace :refinery do

  namespace :marketing do

    # call this task by running: rake refinery:brands:my_task
    # desc "Description of my task below"
    # task :my_task => :environment do
    #   # add your logic here
    # end


    namespace :base do

      desc 'Synchronise Contacts with Base'
      task :synchronise => :environment do
        Refinery::Marketing::BaseSynchroniser.new.synchronise
      end

    end

  end

end
