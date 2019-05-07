module Refinery
  module Marketing
    Contact.class_eval do

      after_save do
        push_changes_to_insightly id, changes
      end

      def push_changes_to_insightly(contact_id, changes)
        contact = Refinery::Marketing::Contact.find(contact_id)
        synchroniser = Refinery::Marketing::Insightly::Synchroniser.new
        synchroniser.push contact, changes

        if synchroniser.error
          ErrorMailer.error_email(synchroniser.error).deliver
        end
      rescue StandardError => e
        ErrorMailer.error_email(e).deliver
      end
      handle_asynchronously :push_changes_to_insightly

    end
  end
end
