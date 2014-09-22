require 'open-uri'
require 'csv'

module Refinery
  module SalesOrders
    module Cin7Importer
      API_ID = ENV['CIN7_API_ID']
      API_KEY = ENV['CIN7_API_KEY']

      module GetOrders

        FIELDS = []
        FIELDS[(FIELD_ORDER_ID = 0)] = 'OrderId'
        FIELDS[(FIELD_ORDER_SESSION_ID = 1)] = 'OrderSessionId'
        FIELDS[(FIELD_ORDER_REF = 2)] = 'OrderRef'
        FIELDS[(FIELD_CREATED_DATE = 3)] = 'CreatedDate'
        FIELDS[(FIELD_MODIFIED_DATE = 4)] = 'ModifiedDate'
        FIELDS[(FIELD_INACTIVE = 5)] = 'Active'
        FIELDS[(FIELD_TRANSACTION_TYPE = 6)] = 'TransactionType'
        FIELDS[(FIELD_MEMBER_ID = 7)] = 'MemberId'
        FIELDS[(FIELD_MEMBER_EMAIL = 8)] = 'MemberEmail'
        FIELDS[(FIELD_MEMBER_COST_CENTER = 9)] = 'MemberCostCenter'
        FIELDS[(FIELD_MEMBER_SESSION_ID = 10)] = 'MemberSessionId'
        FIELDS[(FIELD_SALES_PERSON_ID = 11)] = 'SalesPersonId'
        FIELDS[(FIELD_SALES_PERSON_EMAIL = 12)] = 'SalesPersonEmail'
        FIELDS[(FIELD_PRODUCT_TOTAL = 13)] = 'ProductTotal'
        FIELDS[(FIELD_FREIGHT_TOTAL = 14)] = 'FreightTotal'
        FIELDS[(FIELD_FREIGHT_DESCRIPTION = 15)] = 'FreightDescription'
        FIELDS[(FIELD_DISCOUNT_TOTAL = 16)] = 'DiscountTotal'
        FIELDS[(FIELD_DISCOUNT_DESCRIPTION = 17)] = 'DiscountDescription'
        FIELDS[(FIELD_TOTAL = 18)] = 'Total'
        FIELDS[(FIELD_CURRENCY_RATE = 19)] = 'CurrencyRate'
        FIELDS[(FIELD_CURRENCY_NAME = 20)] = 'CurrencyName'
        FIELDS[(FIELD_CURRENCY_SYMBOL = 21)] = 'CurrencySymbol'
        FIELDS[(FIELD_TAX_STATUS = 22)] = 'TaxStatus'
        FIELDS[(FIELD_TAX_RATE = 23)] = 'TaxRate'
        FIELDS[(FIELD_FIRST_NAME = 24)] = 'FirstName'
        FIELDS[(FIELD_LAST_NAME = 25)] = 'LastName'
        FIELDS[(FIELD_COMPANY = 26)] = 'Company'
        FIELDS[(FIELD_PHONE = 27)] = 'Phone'
        FIELDS[(FIELD_MOBILE = 28)] = 'Mobile'
        FIELDS[(FIELD_EMAIL = 29)] = 'Email'
        FIELDS[(FIELD_DELIVERY_FIRST_NAME = 30)] = 'DeliveryFirstName'
        FIELDS[(FIELD_DELIVERY_LAST_NAME = 31)] = 'DeliveryLastName'
        FIELDS[(FIELD_DELIVERY_COMPANY = 32)] = 'DeliveryCompany'
        FIELDS[(FIELD_DELIVERY_ADDRESS = 33)] = 'DeliveryAddress'
        FIELDS[(FIELD_DELIVERY_SUBURB = 34)] = 'DeliverySuburb'
        FIELDS[(FIELD_DELIVERY_CITY = 35)] = 'DeliveryCity'
        FIELDS[(FIELD_DELIVERY_POSTAL_CODE = 36)] = 'DeliveryPostalCode'
        FIELDS[(FIELD_DELIVERY_STATE = 37)] = 'DeliveryState'
        FIELDS[(FIELD_DELIVERY_COUNTRY = 38)] = 'DeliveryCountry'
        FIELDS[(FIELD_BILLING_FIRST_NAME = 39)] = 'BillingFirstName'
        FIELDS[(FIELD_BILLING_LAST_NAME = 40)] = 'BillingLastName'
        FIELDS[(FIELD_BILLING_COMPANY = 41)] = 'BillingCompany'
        FIELDS[(FIELD_BILLING_ADDRESS = 42)] = 'BillingAddress'
        FIELDS[(FIELD_BILLING_SUBURB = 43)] = 'BillingSuburb'
        FIELDS[(FIELD_BILLING_CITY = 44)] = 'BillingCity'
        FIELDS[(FIELD_BILLING_POSTAL_CODE = 45)] = 'BillingPostalCode'
        FIELDS[(FIELD_BILLING_STATE = 46)] = 'BillingState'
        FIELDS[(FIELD_BILLING_COUNTRY = 47)] = 'BillingCountry'
        FIELDS[(FIELD_COMMENTS = 48)] = 'Comments'
        FIELDS[(FIELD_VOUCHER_CODE = 49)] = 'VoucherCode'
        FIELDS[(FIELD_BRANCH_ID = 50)] = 'BranchId'
        FIELDS[(FIELD_BRANCH_EMAIL = 51)] = 'BranchEmail'
        FIELDS[(FIELD_STAGE = 52)] = 'Stage'
        FIELDS[(FIELD_COST_CENTER = 53)] = 'CostCenter'
        FIELDS[(FIELD_TRACKING_CODE = 54)] = 'TrackingCode'
        FIELDS[(FIELD_PAYMENT_TERMS = 55)] = 'PaymentTerms'

      end

      module GetOrderDetails

        FIELDS = []

        FIELDS[(FIELD_ORDER_DETAIL_ID = 0)] = 'OrderDetailId'
        FIELDS[(FIELD_ORDER_DETAIL_IMPORTED_REF = 1)] = 'OrderDetailImportedRef'
        FIELDS[(FIELD_ORDER_ID = 2)] = 'OrderId'
        FIELDS[(FIELD_ORDER_REF = 3)] = 'OrderRef'
        FIELDS[(FIELD_CREATED_DATE = 4)] = 'CreatedDate'
        FIELDS[(FIELD_ACTIVE = 5)] = 'Active'
        FIELDS[(FIELD_SKU = 6)] = 'SKU'
        FIELDS[(FIELD_CODE = 7)] = 'Code'
        FIELDS[(FIELD_PRODUCT_ID = 8)] = 'ProductId'
        FIELDS[(FIELD_STYLE_CODE = 9)] = 'StyleCode'
        FIELDS[(FIELD_MASTER_ID = 10)] = 'MasterId'
        FIELDS[(FIELD_PRICE = 11)] = 'Price'
        FIELDS[(FIELD_QTY = 12)] = 'Qty'
        FIELDS[(FIELD_NAME = 13)] = 'Name'
        FIELDS[(FIELD_DISCOUNT = 14)] = 'Discount'
        FIELDS[(FIELD_OPTION_1 = 15)] = 'Option1'
        FIELDS[(FIELD_OPTION_2 = 16)] = 'Option2'
        FIELDS[(FIELD_OPTION_3 = 17)] = 'Option3'
        FIELDS[(FIELD_LINE_COMMENTS = 18)] = 'LineComments'

      end

      class << self

        def get_orders(*args)
          options = args.extract_options!

          CSV.parse(get('GetOrders', GetOrders::FIELDS, options[:where], options[:order_by]))
        end

        def get_order_details(*args)
          options = args.extract_options!

          CSV.parse(get('GetOrderDetails', GetOrderDetails::FIELDS, options[:where], options[:order_by]))
        end

        def base_url
          "https://secure.datumconnect.com/cloud/APILite/APILite.ashx?apiid=#{API_ID}&apikey=#{API_KEY}"
        end

        def get(action, fields, where, order_by)
          fields = "&fields=#{ fields.join(',') }"
          where = "&where=#{ URI.escape(where) }" unless where.nil?
          order_by = "&order_by=#{ URI.escape(order_by) }" unless order_by.nil?
          open "#{base_url}&action=#{ action }#{fields}#{where}#{order_by}"
        end

      end

    end
  end
end
