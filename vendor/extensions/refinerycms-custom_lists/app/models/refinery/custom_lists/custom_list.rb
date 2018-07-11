module Refinery
  module CustomLists
    class CustomList < Refinery::Core::BaseModel
      self.table_name = 'refinery_custom_lists_custom_lists'

      has_many :list_columns, dependent: :destroy
      has_many :list_rows,    dependent: :destroy

      attr_accessible :title, :position

      validates :title, :presence => true, :uniqueness => true

      def data
        list_rows.includes(:list_cells).map { |list_row|
          list_row.data_for(list_columns)
        }
      end
    end
  end
end
