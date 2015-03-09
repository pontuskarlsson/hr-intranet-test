module Refinery
  module Parcels
    class UnsignedParcelsMailer < ActionMailer::Base

      def notification(user, parcels)
        @parcels = parcels
        mail :subject => 'You have unsigned Parcels waiting',
             :to => user.email,
             :from => "\"#{Refinery::Core.site_name}\" <#{ Refinery::Parcels.mailer_from_address }>"
      end

    end
  end
end
