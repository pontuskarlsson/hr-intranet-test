module Refinery
  module Shipping
    class Document < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_documents'

      TYPES = %w(air_waybill cmr_waybill rail_waybill bill_of_lading packing_list commercial_invoice insurance country_of_origin other)

      attr_accessor :file # For form accessor upon creation

      belongs_to :shipment
      belongs_to :resource

      validates :shipment_id,           presence: true
      validates :resource_id,           presence: true, uniqueness: { scope: :shipment_id }
      validates :document_type,         inclusion: TYPES
      validates :comments,              presence: true, if: -> { document_type == 'other' }

      def display_document_type
        if document_type.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.document_types.#{document_type}"
        end
      end

      def self.document_type_options
        ::I18n.t("activerecord.attributes.#{model_name.i18n_key}.document_types").reduce(
            [[::I18n.t("refinery.please_select"), { disabled: true }]]
        ) { |acc, (k,v)| acc << [v,k] }
      end
      
    end
  end
end
