namespace :refinery do

  namespace :shipping do

    # call this task by running: rake refinery:shipping:my_task
    # desc "Description of my task below"
    # task :my_task => :environment do
    #   # add your logic here
    # end


    task :notify_about_parcels => :environment do

      ::Refinery::Shipping::Parcel.unsigned.group_by(&:assigned_to).each do |user, parcels|
        if user.current_employment_contract.present?
          ::Refinery::Shipping::UnsignedParcelsMailer.notification(user, parcels).deliver
        end
      end

    end

  end

end