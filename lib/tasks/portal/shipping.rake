namespace :portal do
  namespace :shipping do

    task send_status_request: :environment do
      begin
        shipments_by_forwarder = Refinery::Shipping::Shipment.active.forwarder.group_by(&:forwarder_company)

        shipments_by_forwarder.each_pair do |forwarder, shipments|
          shipments.each do |shipment|
            shipment.notify :'refinery/authentication/devise/users',
                            key: 'shipment.status_request'
          end
        end

        # Send batch notification email to the users with unopened notifications of specified key in 1 hour
        Refinery::Authentication::Devise::User.send_batch_unopened_notification_email(
            batch_key: 'batch.shipment.status_request',
            filtered_by_key: 'shipment.status_request',
            custom_filter: ["created_at >= ?", 1.hour.ago]
        )

      rescue StandardError => e
        ErrorMailer.error_email(e).deliver
      end
    end

    task send_status_summary: :environment do
      begin
        #shipments_by_consignee = Refinery::Shipping::Shipment.shipped.consignee.group_by(&:consignee_company)
        shipments_by_consignee = Refinery::Shipping::Shipment.where(id: 1398).group_by(&:consignee_company)

        shipments_by_consignee.each_pair do |consignee, shipments|
          shipments.each do |shipment|
            shipment.notify :'refinery/authentication/devise/users',
                            key: 'shipment.status_summary'
          end
        end

        # Send batch notification email to the users with unopened notifications of specified key in 1 hour
        Refinery::Authentication::Devise::User.send_batch_unopened_notification_email(
            batch_key: 'batch.shipment.status_summary',
            filtered_by_key: 'shipment.status_summary',
            custom_filter: ["created_at >= ?", 1.hour.ago]
        )

      rescue StandardError => e
        ErrorMailer.error_email(e).deliver
      end
    end

  end
end
