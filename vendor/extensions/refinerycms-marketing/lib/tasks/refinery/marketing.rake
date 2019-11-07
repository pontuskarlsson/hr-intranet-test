namespace :refinery do
  namespace :marketing do

    namespace :insightly do

      desc 'Synchronise Contacts with Insightly'
      task :synchronise => [:set_logger, :environment] do
        synchroniser = Refinery::Marketing::Insightly::Synchroniser.new
        synchroniser.pull_all

        if synchroniser.error.present?
          ErrorMailer.error_email(synchroniser.error).deliver if defined?(ErrorMailer)
        end
      end


      task set_logger: :environment do
        if Rails.env.development?
          Rails.logger = Logger.new(STDOUT)
        end
      end

    end

  end
end
