namespace :refinery do

  namespace :parcels do

    # call this task by running: rake refinery:parcels:my_task
    # desc "Description of my task below"
    # task :my_task => :environment do
    #   # add your logic here
    # end


    task :notify_about_parcels => :environment do

      ::Refinery::Parcels::Parcel.unsigned.group_by(&:assigned_to).each do |user, parcels|
        if user.current_employment_contract.present?
          ::Refinery::Parcels::UnsignedParcelsMailer.notification(user, parcels).deliver
        end
      end

    end

  end

end