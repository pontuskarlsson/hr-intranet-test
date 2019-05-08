namespace :hr_intranet do
  namespace :insightly do

    desc 'Synchronise Contacts with Insightly'
    task :synchronise => [:set_logger, :environment] do
      return

      synchroniser = Refinery::Marketing::Insightly::Synchroniser.new
      synchroniser.pull_all

      if synchroniser.error.present?
        ErrorMailer.new(synchroniser.error).deliver
      end
    end


    task set_logger: :environment do
      if Rails.env.development?
        Rails.logger = Logger.new(STDOUT)
      end
    end

  end
end
