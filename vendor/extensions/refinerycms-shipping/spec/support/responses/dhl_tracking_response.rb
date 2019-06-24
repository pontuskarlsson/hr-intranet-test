module Refinery
  module Shipping

    class DhlTrackingResponse

      def self.success

        {
            "results" => [
                {
                    "id" => "123456789",
                    "label" => "Waybill",
                    "type" => "airwaybill",
                    "duplicate" => false,
                    "delivery" => {
                        "code" => "101",
                        "status" => "delivered"
                    },
                    "origin" => {
                        "value" => "HONG KONG - HONG KONG - HONG KONG",
                        "label" => "Origin Service Area",
                        "url" => "http://www.dhl.com.hk/en/country_profile.html"
                    },
                    "destination" => {
                        "value" => "NEW YORK, NY - NEW YORK NY - USA",
                        "label" => "Destination Service Area",
                        "url" => "http://www.dhl-usa.com/en/country_profile.html"
                    },
                    "description" => "Signed for by: J Doe Tuesday, May 12, 2015  at 16:45",
                    "hasDuplicateShipment" => false,
                    "signature" => {
                        "link" => {
                            "url" => "",
                            "label" => ""
                        },
                        "type" => "none",
                        "description" => "Tuesday, May 12, 2015  at 16:45",
                        "signatory" => "J Doe",
                        "label" => "Signed for by",
                        "help" => "help"
                    },
                    "pieces" => {
                        "value" => 1,
                        "label" => "Piece",
                        "showSummary" => true,
                        "pIds" => [ "JD0123456789123456789" ]
                    },
                    "checkpoints" => [
                        {
                            "counter" => 3,
                            "description" => "Delivered - Signed for by => J Doe",
                            "time" => "16:45",
                            "date" => "Tuesday, May 12, 2015 ",
                            "location" => "NEW YORK NY                        ",
                            "totalPieces" => 1,
                            "pIds" => [ "JD0123456789123456789" ]
                        }, {
                            "counter" => 2,
                            "description" => "Arrived at Sort Facility  HONG KONG - HONG KONG",
                            "time" => "20:46",
                            "date" => "Monday, May 11, 2015 ",
                            "location" => "HONG KONG - HONG KONG",
                            "totalPieces" => 1,
                            "pIds" => [ "JD0123456789123456789" ]
                        }, {
                            "counter" => 1,
                            "description" => "Shipment picked up",
                            "time" => "17:07",
                            "date" => "Monday, May 11, 2015 ",
                            "location" => "HONG KONG - HONG KONG"
                        }
                    ],
                    "checkpointLocationLabel" => "Location",
                    "checkpointTimeLabel" => ``"Time"
                }
            ]
        }
        
      end

    end

  end
end
