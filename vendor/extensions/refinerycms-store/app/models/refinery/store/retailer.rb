module Refinery
  module Store
    class Retailer < Refinery::Core::BaseModel
      self.table_name = 'refinery_store_retailers'

      has_many :products, dependent: :destroy
      has_many :orders, dependent: :destroy

      attr_accessible :name, :default_price_unit, :position

      validates :name,                presence: true, uniqueness: true
      validates :default_price_unit,  presence: true

      class << self
        def not_expired
          where("#{table_name}.expired_at IS NULL")
        end
      end
    end
  end
end
