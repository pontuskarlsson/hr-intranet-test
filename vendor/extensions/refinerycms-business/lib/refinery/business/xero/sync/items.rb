module Refinery
  module Business
    module Xero
      module Sync
        class Items

          SYNC_ATTRIBUTES = {
              code: :code,
              name: :name,
              description: :description,
              is_sold: :is_sold,
              is_purchased: :is_purchased,
              updated_date_utc: :updated_date_utc,
          }.freeze

          attr_reader :account, :errors

          def initialize(account, errors)
            @account = account
            @errors = errors
          end

          def sync!(xero_item)
            article = account.articles.find_by(item_id: xero_item.item_id)
            article = account.articles.find_by(code: xero_item.code, item_id: "") if article.nil?
            article = account.articles.build(item_id: xero_item.item_id) if article.nil?

            article.attributes = SYNC_ATTRIBUTES.each_with_object({}) { |(local, remote), acc|
              acc[local] = xero_item.attributes[remote]
            }

            article.save!
          rescue ::ActiveRecord::ActiveRecordError => e
            errors << e
          end

        end
      end
    end
  end
end
