module Refinery
  module Parcels
    class ShipmentParcel < Refinery::Core::BaseModel
      PREDEFINED_PACKAGES = {
          'SF Express' => %w(),
          'UPS' => %w(UPSLetter UPSExpressBox UPS25kgBox UPS10kgBox Tube Pak Pallet SmallExpressBox MediumExpressBox LargeExpressBox),
          'DHL' => %w(JumboDocument JumboParcel Document DHLFlyer Domestic ExpressDocument DHLExpressEnvelope JumboBox JumboJuniorDocument JuniorJumboBox JumboJuniorParcel OtherDHLPackaging Parcel YourPackaging)
      }.freeze

      self.table_name = 'refinery_parcels_shipment_parcels'

      belongs_to :shipment

      attr_accessible :length, :width, :height, :weight, :predefined_package

      validates :weight,              presence: true
      validates :predefined_package,  inclusion: { in: Proc.new { |sp| PREDEFINED_PACKAGES[sp.shipment.try(:courier)] } }, allow_blank: true

    end
  end
end
