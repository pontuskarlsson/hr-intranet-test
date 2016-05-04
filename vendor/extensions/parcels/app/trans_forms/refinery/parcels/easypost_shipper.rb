require 'easypost'

module Refinery
  module Parcels
    class EasypostShipper < TransForms::FormBase
      RATIO_KG_TO_OZ = 35.274
      RATIO_CM_TO_IN = 0.393701

      set_main_model :shipment, proxy: { attributes: %w(bill_to_account_id courier) }, class_name: '::Refinery::Parcels::Shipment'

      attribute :shipment_parcels_attributes,   Hash, default: {}
      attribute :rate_id,                       String

      validates :shipment,      presence: true
      validates :rate_id,       inclusion: { in: proc { |f| (f.shipment.try(:rates_content) || []).map { |r| r[:id] } } }, allow_blank: true
      validate do
        errors.add(:status, 'Shipment is already Shipped') if shipment.try(:status) != 'not_shipped'
      end

      delegate :shipment_parcels, to: :shipment

      ### Form Transaction ###
      transaction do
        update_courier_and_account!

        update_parcel_attributes! if shipment_parcels_attributes.any?

        get_rates_from_easy_post! if shipment.easypost_object_id.blank? && shipment.shipment_parcels.any? && parcels_ready_to_ship?

        buy_shipment_rate! if rate_id.present?
      end

      private

      # A method to update the courier and/or the ShipmentAccount that the
      # shipment should be billed to. If the shipment should be billed to the
      # Sender, then we only need to specify Courier at this stage, since
      # EasyPost keeps track of all of our own Accounts.
      # If the Shipment should be billed to the Receiver, then we make sure
      # that the chosen account is either belonging to the ToContact of the
      # Shipment, or that Contact's Organisation.
      # And lastly, if the Shipment should be billed to a 3rd Party, then we
      # allow any Account to be selected (a scenario that we must be careful
      # with).
      def update_courier_and_account!
        if shipment.bill_to == 'Sender'
          shipment.courier = courier

        elsif shipment.bill_to == 'Receiver'
          if shipment.to_contact.present?
            # Makes sure that the ShipmentAccount is a valid account (belongs to either ToContact or ToContact's Organisation)
            account = ShipmentAccount.where('contact_id IN (?)', [shipment.to_contact.id, shipment.to_contact.organisation_id].compact).find bill_to_account_id
            shipment.bill_to_account_id = account.id
            shipment.courier = account.courier
          else
            raise 'Cannot find Account to bill to without a Contact selected', ::ActiveRecord::RecordNotSaved
          end

        elsif shipment.bill_to == '3rd Party'
          account = ShipmentAccount.find bill_to_account_id
          shipment.bill_to_account_id = account.id
          shipment.courier = account.courier

        end

        shipment.save!
      end

      # In this method, we update the attributes for the ShipmentParcels for
      # the current Shipment. It includes specifying the type or measurements
      # for the Parcel, and if it is an International shipment, then it is
      # required to add Customs Info as well
      def update_parcel_attributes!(allowed_attr = %w(description predefined_package weight length height width contents_type origin_country quantity value))
        shipment_parcels_attributes.values.each do |attr|
          attr.stringify_keys!
          shipment_parcel = shipment.shipment_parcels.detect { |sp| sp.id == attr['id'].to_i } || (raise ActiveRecord::RecordNotFound)
          shipment_parcel.attributes = attr.reject { |k,_| !allowed_attr.include?(k) }
          shipment_parcel.save_for_easypost!
        end
      end

      # A method to evaluate all ShipmentParcels for the Shipment, to see if they
      # have all the required attributes set, to be able to ship with EasyPost.
      def parcels_ready_to_ship?
        shipment.shipment_parcels.all? { |sp| sp.valid_for_easypost?(shipment.international?) }
      end

      # When all parcels are valid for EasyPost shipment, then this method will
      # create objects in EasyPost and retrieve the rates
      def get_rates_from_easy_post!
        to_address = easy_post_address_for shipment.to_address
        from_address = easy_post_address_for shipment.from_address

        order_hash = {
            to_address: to_address,
            from_address: from_address,
            shipments: shipment.shipment_parcels.map { |sp|
              shipment_hash_for(sp)
            }
        }

        if shipment.bill_to == 'Receiver'
          if shipment.bill_to_account.present?
            order_hash[:options] = { bill_receiver_account: shipment.bill_to_account.account_no }
            order_hash[:options][:bill_receiver_postal_code] = shipment.to_address.zip if shipment.courier == 'UPS'
          else
            raise ActiveRecord::RecordNotSaved
          end

        elsif shipment.bill_to == '3rd Party'
          if shipment.bill_to_account.present?
            order_hash[:options] = { bill_third_party_account: shipment.bill_to_account.account_no }
            if shipment.courier == ::Refinery::Parcels::Shipment::COURIER_UPS
              order_hash[:options][:bill_third_party_country] = shipment.to_address.country
              order_hash[:options][:bill_third_party_postal_code] = shipment.to_address.zip
            end
          else
            raise ActiveRecord::RecordNotSaved
          end

        end

        order = EasyPost::Order.create(order_hash)

        # Save the EasyPost object id so that we can referr to it lates, as well
        # as a Hash representation of the Rates returned by EasyPost.
        shipment.easypost_object_id = order.id
        shipment.rates_content = order.rates.map(&:to_h)
        shipment.save!
      end

      # This method will either retrieve an existing easy post record if it
      # had already been created at an earlier time. Otherwise it will create
      # a ned Address record and associate it with the ShipmentAddress record.
      def easy_post_address_for(shipment_address)
        EasyPost::Address.create(
            name:     shipment_address.name,
            street1:  shipment_address.street1,
            street2:  shipment_address.street2,
            city:     shipment_address.city,
            state:    shipment_address.state,
            zip:      shipment_address.zip,
            country:  shipment_address.country,
            email:    shipment_address.email,
            phone:    shipment_address.phone
        )
      end

      def shipment_hash_for(shipment_parcel)
        hash = {
            parcel: parcel_hash_for(shipment_parcel),
            options: { label_format: 'PDF' }
        }

        if shipment.international?
          hash[:customs_info] = customs_hash_for(shipment_parcel)
        end

        hash
      end

      # A method that will parse the settings for a ShipmentParcel and return
      # a hash in the format that the EasyPost API uses.
      def parcel_hash_for(shipment_parcel)
        if shipment_parcel.predefined_package.present?
          { predefined_package: shipment_parcel.predefined_package, weight: (shipment_parcel.weight * RATIO_KG_TO_OZ).round(1) }
        else
          { length: (shipment_parcel.length * RATIO_CM_TO_IN).round(1), width: (shipment_parcel.width * RATIO_CM_TO_IN).round(1), height: (shipment_parcel.height * RATIO_CM_TO_IN).round(1), weight: (shipment_parcel.weight * RATIO_KG_TO_OZ).round(1) }
        end
      end

      # A method that will parse the settings for a ShipmentParcel and return
      # a hash in the format that the EasyPost API uses.
      def customs_hash_for(shipment_parcel)
        hash = {
            customs_certify: true,
            customs_signer: shipment_parcel.shipment.from_address.try(:name),
            customs_items: [{ description: shipment_parcel.description,
                              quantity: shipment_parcel.quantity,
                              value: shipment_parcel.value, # in USD
                              weight: (shipment_parcel.weight * RATIO_KG_TO_OZ).round(1),
                              origin_country: shipment_parcel.origin_country
                            }]
        }

        if Refinery::Parcels::ShipmentParcel::DEFAULT_CONTENTS_TYPES.include? shipment_parcel.contents_type
          hash[:contents_type] = shipment_parcel.contents_type
        else
          hash[:contents_type] = 'other'
          hash[:contents_explanation] = shipment_parcel.contents_type
        end

        hash
      end

      # This method will try to purchase one of the Rates returned by EasyPost.
      def buy_shipment_rate!
        order = EasyPost::Order.retrieve shipment.easypost_object_id
        rate = order.rates.detect { |r| r.id == rate_id } || (raise ActiveRecord::RecordNotFound)
        order.buy(carrier: shipment.courier, service: rate.service)

        shipment.rate_object_id =   rate.id
        shipment.rate_service =     rate.service
        shipment.rate_amount =      rate.rate
        shipment.rate_currency =    rate.currency

        shipment.status =           order.shipments[0].status
        shipment.tracking_number =  order.shipments[0].tracking_code
        shipment.label_url =        order.shipments[0].postage_label.label_url

        shipment.shipping_date = Date.today

        shipment.save!

        # If an EasyPost error occurs, then we log the message and then raise
        # an ActiveRecord error to abort the Transaction.
      rescue EasyPost::Error => e
        Rails.logger.debug e.message
        raise ActiveRecord::RecordNotFound
      end

    end

  end
end
