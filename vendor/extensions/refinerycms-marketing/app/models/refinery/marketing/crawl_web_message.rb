require 'json'

module Refinery
  module Marketing
    class CrawlWebMessage < Message

      validates :sender_id, :sender_type, presence: true

      def handle_response(msg)
        begin
          obj = JSON.parse(msg)
          if obj['success']
            obj['records'].each do |record_hash|
              # Records are Brands

              if (name = record_hash.delete('name')).present?
                brand = ::Refinery::Brands::Brand.find_or_initialize_by_name(name)
                brand.attributes = record_hash
                brand.save

                if sender.present?
                  sender.brand_shows.find_or_create_by_brand_id(brand.id)
                end
              end

            end
          else
            #fail
          end

        rescue StandardError => e
          Rails.logger.info e.inspect
        end

        # Destroys self
        destroy
      end

    end
  end
end
