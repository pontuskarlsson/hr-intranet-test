module Refinery
  module Shipping
    class UnsignedParcelsMailer < ActionMailer::Base

      def notification(user, parcels)
        @parcels = parcels
        mail :subject => 'You have unsigned Parcels waiting',
             :to => user.email,
             :from => "\"#{Refinery::Core.site_name}\" <#{ Refinery::Shipping.mailer_from_address }>"
      end

    end
  end
end
