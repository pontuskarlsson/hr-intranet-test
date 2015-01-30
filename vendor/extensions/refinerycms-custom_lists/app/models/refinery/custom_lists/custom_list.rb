module Refinery
  module CustomLists
    class CustomList < Refinery::Core::BaseModel
      self.table_name = 'refinery_custom_lists_custom_lists'

      has_many :list_columns, dependent: :destroy
      has_many :list_rows,    dependent: :destroy

      attr_accessible :title, :position

      validates :title, :presence => true, :uniqueness => true
    end
  end
end
