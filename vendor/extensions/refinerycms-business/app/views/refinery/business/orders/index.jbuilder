orders = @orders

json.data orders do |order|
  json.(order, :id, :buyer_label, :seller_label, :order_number, :order_type, :order_date)
  json.(order, :ordered_qty, :total_cost)
end
