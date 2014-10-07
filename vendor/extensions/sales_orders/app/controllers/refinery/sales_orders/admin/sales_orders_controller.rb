module Refinery
  module SalesOrders
    module Admin
      class SalesOrdersController < ::Refinery::AdminController
        skip_before_filter :verify_authenticity_token, only: [:import]

        crudify :'refinery/sales_orders/sales_order',
                :title_attribute => 'order_id',
                :xhr_paging => true,
                order: 'order_ref ASC'

        def import
          latest_date = SalesOrder.select(:modified_date).order('modified_date DESC').first.try(:modified_date)
          #condition = latest_date.nil? ? nil : "ModifiedDate > DateTime('#{latest_date.strftime('%Y-%m-%d %H:%M:%S')}')"
          condition = "ModifiedDate > DateTime('#{ (DateTime.now - 3.days).strftime('%Y-%m-%d %H:%M:%S') }')"

          orders = Refinery::SalesOrders::Cin7Importer.get_orders(where: condition)

          # The first row is the header
          if orders.length > 1

            begin
              SalesOrder.transaction do
                item_conditons = orders[1..-1].map { |row| "OrderId=#{ row[Refinery::SalesOrders::Cin7Importer::GetOrders::FIELD_ORDER_ID] }" }.join(' OR ')
                order_details_result = Refinery::SalesOrders::Cin7Importer.get_order_details(where: item_conditons)
                order_details_headers = order_details_result[0]
                grouped_order_details = order_details_result[1..-1].group_by { |row| row[Refinery::SalesOrders::Cin7Importer::GetOrderDetails::FIELD_ORDER_ID] }

                orders[1..-1].each do |row|
                  order_id = row[Refinery::SalesOrders::Cin7Importer::GetOrders::FIELD_ORDER_ID]

                  order = SalesOrder.find_or_initialize_by_order_id(order_id)

                  # For now we can assume that the name of the cin7 fields match
                  # the model with a direct underscore conversion
                  orders[0].each_with_index do |field, i|
                    order.send("#{ field.underscore }=", row[i]) unless row[i].nil? # Don't set nil for columns with default values
                  end
                  order.save!

                  if (order_details = grouped_order_details[order.order_id]).present?
                    order_details.each do |detail_row|
                      order_detail_id = detail_row[Refinery::SalesOrders::Cin7Importer::GetOrderDetails::FIELD_ORDER_DETAIL_ID]
                      order_item = order.order_items.find_or_initialize_by_order_detail_id(order_detail_id)

                      order_details_headers.each_with_index do |field, i|
                        order_item.send("#{ field.underscore }=", detail_row[i]) unless detail_row[i].nil?
                      end

                      order_item.save!
                    end
                  end
                end
              end

            rescue ActiveRecord::RecordNotSaved => e
              Rails.logger.debug e.inspect
            end
          end

          redirect_to refinery.sales_orders_admin_sales_orders_path
        end

      end
    end
  end
end
