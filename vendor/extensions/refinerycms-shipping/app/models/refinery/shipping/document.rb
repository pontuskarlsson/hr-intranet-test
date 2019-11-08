module Refinery
  module Shipping
    class Document < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_documents'

      TYPES = %w(air_waybill cmr_waybill rail_waybill bill_of_lading packing_list commercial_invoice insurance country_of_origin other)

      attr_accessor :file # For form accessor upon creation

      belongs_to :shipment
      belongs_to :resource

      configure_enumerables :document_type, TYPES

      delegate :file_name, to: :resource, prefix: true, allow_nil: true

      validates :shipment_id,           presence: true
      validates :resource_id,           presence: true, uniqueness: { scope: :shipment_id }
      validates :document_type,         inclusion: TYPES
      validates :comments,              presence: true, if: -> { document_type == 'other' }
      
    end
  end
end
