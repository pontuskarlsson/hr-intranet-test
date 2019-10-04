module Refinery
  module Shipping
    class ShipmentParcel < Refinery::Core::BaseModel
      #DEFAULT_CONTENTS_TYPES = %w(documents gift merchandise returned_goods sample)

      # # Procs used in validations
      # PROC_EASYPOST = Proc.new { |sp| sp._validate_easypost }
      # PROC_NOT_PREDEFINED = Proc.new { |sp| sp._validate_easypost && sp.predefined_package.blank? }
      # PROC_INTERNATIONAL = Proc.new { |sp| sp._validate_international }

      self.table_name = 'refinery_shipping_shipment_parcels'

      belongs_to :shipment

      #attr_reader :_validate_easypost, :_validate_international
      #attr_accessible :length, :width, :height, :weight, :predefined_package, :description, :quantity, :value, :origin_country, :contents_type

      # validates :shipment_id,         presence: true
      # validates :description,         presence: true
      #
      # # Validations related to EasyPost
      # validates :weight,              presence: true, if: PROC_EASYPOST
      # validates :length,              presence: true, if: PROC_NOT_PREDEFINED
      # validates :height,              presence: true, if: PROC_NOT_PREDEFINED
      # validates :width,               presence: true, if: PROC_NOT_PREDEFINED
      # validates :predefined_package,  inclusion: { in: Proc.new { |sp| sp.shipment.try(:courier_predefined_packages) } }, allow_blank: true
      # validates :contents_type,       presence: true, if: PROC_INTERNATIONAL
      # validates :origin_country,      presence: true, if: PROC_INTERNATIONAL
      # validates :quantity,            numericality: { greater_than: 0 }, if: PROC_INTERNATIONAL
      # validates :value,               numericality: { greater_than: 0 }, if: PROC_INTERNATIONAL


      # A method used to validate if a parcel is ready to be shipped.
      # Some attributes are not required when creating ShipmentParcels because
      # sometimes they will just be sent manually, instead of through EasyPost.
      # But when EasyPost is used, we need to make sure that additional attributes
      # are present. Se we use regular validations that are only run when certain
      # procs evaluate to true.
      # def valid_for_easypost?(international = false)
      #   @_validate_easypost, @_validate_international = true, international
      #   valid = valid?
      #   @_validate_easypost, @_validate_international = nil
      #   valid
      # end
      #
      # def save_for_easypost!(international = false)
      #   @_validate_easypost, @_validate_international = true, international
      #   s = save!
      #   @_validate_easypost, @_validate_international = nil
      #   s
      # end

    end
  end
end
