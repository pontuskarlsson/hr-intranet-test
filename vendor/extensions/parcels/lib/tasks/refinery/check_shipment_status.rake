require 'open-uri'
require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

SF_URI = 'http://www.sf-express.com/sf-service-web/service/bills/%WAYBILL%/routes?app=bill&lang=en&region=hk'
DHL_URI = 'http://www.dhl.com.hk/shipmentTracking?AWB=%WAYBILL%&countryCode=hk&languageCode=en'
UPS_HOST = 'https://wwwapps.ups.com'
UPS_URI = '/WebTracking/track'
UPS_BODY = 'loc=en_US&HTMLVersion=5.0&trackNums=%WAYBILL%&track.x=Track'

namespace :refinery do

  namespace :parcels do

    # A task that will check any Shipments that have been shipped, but not yet
    # received. Depending on what courier was used and whether or not EasyPost
    # was used to ship it, it will use different methods to check the status.
    task :check_shipment_status => :environment do

      Refinery::Parcels::Shipment.shipped_manually_not_delivered.each do |shipment|
        begin
          if shipment.courier == Refinery::Parcels::Shipment::COURIER_SF

            io = open(SF_URI.gsub('%WAYBILL%', shipment.tracking_number.gsub(' ', '')))
            response = JSON.parse(io.readline)

            # The response should be an Array with one entry, and that entry
            # should be a Hash with the Shipment information. If the Array is
            # empty, than we either have an invalid Tracking Number, or the
            # shipment has not yet been registered in the Courier's system.
            # But if it is registered, then the parsed length of the response
            # should be 1.
            if response.count == 1
              entry = response.first

              shipment.tracking_info = entry['routes'].map { |route|
                { 'date' => DateTime.parse(route['scanDateTime']) - 8.hours, 'message' => Nokogiri::HTML.parse(route['remark']).text }
              }

              shipment.status = 'delivered' if entry['delivered']
              shipment.save

            end

          elsif shipment.courier == Refinery::Parcels::Shipment::COURIER_DHL

            io = open(DHL_URI.gsub('%WAYBILL%', shipment.tracking_number.gsub(' ', '')))
            response = JSON.parse(io.read)

            if response.is_a?(Hash) && response.has_key?('results') && response['results'].count == 1
              entry = response['results'].first

              shipment.tracking_info = entry['checkpoints'].reverse.map { |route|
                if route['date'] && route['time']
                  { 'date' => DateTime.parse(route['date'] + route['time']) - 8.hours, 'message' => Nokogiri::HTML.parse(route['description']).text }
                end
              }.compact

              shipment.status = 'delivered' if entry['delivery'] && entry['delivery']['status'] == 'delivered'
              shipment.save
            end

          elsif shipment.courier == Refinery::Parcels::Shipment::COURIER_UPS

            # The UPS tracking page does not respond to JSON request and can
            # only return HTML responses. So we have to use Nokogiri to parse
            # the reply and see if we can find any status about the Shipment.
            uri = URI.parse(UPS_HOST)
            req = Net::HTTP::Post.new(UPS_URI)
            req.body = UPS_BODY.gsub('%WAYBILL%', shipment.tracking_number.gsub(' ', ''))
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            response = http.start{ |http| http.request(req) }

            doc = Nokogiri::HTML.parse response.body

            if (nodes = doc.css('.newpkgProgress .newstatus .current a#tt_spStatus')).count == 1
              shipment.status = 'delivered' if nodes.text.strip == 'Delivered'
              shipment.save
            end

          else
            shipment.status = 'unknown'
            shipment.save
          end


        rescue OpenURI::HTTPError => e
          # Something went wrong while trying to open the remote web uri. We set
          # the status of the Shipment to unknown so that it wont be checked
          # again.
          shipment.tracking_info = [{ 'date' => DateTime.now, 'message' => 'Could not load remote URI', 'error' => true }]
          shipment.status = 'unknown'
          shipment.save

        rescue EOFError => e
          # Something went wrong while trying to read the body from the response.
          # We set the status of the Shipment to unknown so that it wont be checked
          # again.
          shipment.tracking_info = [{ 'date' => DateTime.now, 'message' => 'Could not read response from remote URI', 'error' => true }]
          shipment.status = 'unknown'
          shipment.save

        rescue JSON::ParserError => e
          # Something went wrong while trying to parse the response body as JSON.
          # We set the status of the Shipment to unknown so that it wont be checked
          # again.
          shipment.tracking_info = [{ 'date' => DateTime.now, 'message' => 'Could not handle response from remote URI', 'error' => true }]
          shipment.status = 'unknown'
          shipment.save

        end
      end

    end

  end

end