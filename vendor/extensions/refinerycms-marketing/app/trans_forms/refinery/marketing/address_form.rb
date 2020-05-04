module Refinery
  module Marketing
    class AddressForm < ApplicationTransForm

      PROXY_ATTR = %w(address1 address2 postal_code city province country)

      set_main_model :address, class_name: '::Refinery::Marketing::Address',
                                      proxy: { attributes: PROXY_ATTR }

      attribute :relation,    String

      attr_accessor :contact, :link

      validates :relation,      presence: true

      def model=(model)
        if model.is_a?(::Refinery::Marketing::Contact)
          self.link = model.links.detect { |link| link.address_link? && link.relation == relation }
          self.address = link&.linked || Refinery::Marketing::Address.new(owner_id: model.owner_id)
          self.contact = model
        else
          self.address = model
        end
      end

      def country_code=(country_code)
        self.country = ISO3166::Country[country_code]&.name
      end

      def country_code
        address&.country_code
      end

      # This should be moved to TransForms lib, called when form is used in +fields_for+
      def id
        address&.id
      end

      transaction do
        if fields.values.any?(&:present?)
          address.attributes = fields
          address.save!

          if contact.present?
            self.link ||= contact.links.build(linked: address, relation: relation)
            link.save!
          end

        elsif address.persisted?
          address.destroy!
        end
      end

      private

      def fields
        PROXY_ATTR.reduce({}) do |acc, field|
          acc.merge field => send(field)
        end
      end

    end
  end
end
