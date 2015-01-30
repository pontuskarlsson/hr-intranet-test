module Refinery
  module Marketing
    class BrandShow < Refinery::Core::BaseModel
      self.table_name = 'refinery_brand_shows'

      belongs_to :brand
      belongs_to :show

      attr_accessible :brand_id, :show_id

      validates :brand_id, :show_id, presence: true, uniqueness: true

    end
  end
end
