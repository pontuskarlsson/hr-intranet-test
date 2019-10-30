namespace :portal do
  namespace :business do
    namespace :xero do

      desc 'Synchronise Changes from Xero'
      task sync_changes: [:set_logger, :environment] do
        begin
          Refinery::Business::Account.find_each do |account|
            syncer = Refinery::Business::Xero::Syncer.new account
            syncer.sync_changes!

            ErrorMailer.error_email(syncer.errors[0], syncer.errors[1..-1]).deliver if syncer.errors.any?
          end

        rescue StandardError => e
          ErrorMailer.error_email(e).deliver
        end
      end


      desc 'Synchronise All records with Xero'
      task sync_all: [:set_logger, :environment] do
        begin
          Refinery::Business::Account.find_each do |account|
            syncer = Refinery::Business::Xero::Syncer.new account
            syncer.sync_all!

            ErrorMailer.error_email(syncer.errors[0], syncer.errors[1..-1]).deliver if syncer.errors.any?
          end

        rescue StandardError => e
          ErrorMailer.error_email(e).deliver
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
