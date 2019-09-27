require "#{Rails.root}/lib/delayed_job/push_contact_job"

module Refinery
  module Marketing
    Contact.class_eval do

      after_save do
        if Refinery::Marketing::Insightly.configuration.updates_allowed
          Delayed::Job.enqueue(PushContactJob.new(id, changes)) if changes.any?
        end
      end

    end
  end
end
