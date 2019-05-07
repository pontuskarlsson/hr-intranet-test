require 'api_client'

module Refinery
  module Marketing
    module Insightly
      class ResourceList
        include Enumerable

        def initialize(client, resource, batch_size = 100)
          @client, @resource, @batch_size = client, resource, batch_size
          @batch_size = 100 if batch_size < 1
        end

        def each(&block)
          if @records.nil?
            @records = []

            # Request once in raw format to get the total number of records through the header
            res = @client.params(count_total: true, skip: 0, top: 1).get(@resource, raw: true)

            # Iterate the total number of records and load them in batches from Insightly
            res.headers['x-total-count'].to_i.times do |i|
              if i % @batch_size == 0
                @records += @client.params(skip: i, top: @batch_size).get(@resource).map { |r| Refinery::Marketing::Resource.new r }
              end
              block.call @records[i]
            end

          else
            @records.each(&block)
          end

        rescue ApiClient::Errors::ApiClientError => e
          puts e.inspect
        end

      end
    end
  end
end
