Refinery::Parcels::ShipmentsController.class_eval do

  def index
    @shipment = ::Refinery::Parcels::Shipment.new(from_contact_id: current_refinery_user.contact.try(:id))
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @parcel in the line below:
    present(@page)
  end

  def easypost_ship
    @easypost_shipper = Refinery::Parcels::EasypostShipper.new({ shipment: @shipment }.reverse_merge(params[:shipment] || {}))
    respond_to do |format|
      if @easypost_shipper.save
        format.js {  }
        format.html {
          flash[:notice] = 'Shipment successfully Updated.'
          redirect_to refinery.parcels_shipment_path(@shipment)
        }
      else
        format.js {  }
        format.html {
          present(@page)
          render action: :show
        }
      end
    end
  end

end
