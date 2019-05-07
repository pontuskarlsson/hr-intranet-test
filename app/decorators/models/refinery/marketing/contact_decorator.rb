module Refinery
  module Marketing
    Contact.class_eval do

      after_save :push_changes_to_insightly

      def push_changes_to_insightly
        synchroniser = Refinery::Marketing::Insightly::Synchroniser.new
        synchroniser.push self

        if synchroniser.error
          ErrorMailer.new(synchroniser.error).deliver
        end
      end
      handle_asynchronously :push_changes_to_insightly

    end
  end
end
