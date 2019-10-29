module Refinery
  module Business
    class Article < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_articles'

      belongs_to :company

      validates :item_id,     uniqueness: true, allow_blank: true
      validates :code,        uniqueness: { scope: :company_id }

      def label
        code
      end



    end
  end
end
