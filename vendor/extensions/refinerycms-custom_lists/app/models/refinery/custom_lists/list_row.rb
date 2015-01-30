module Refinery
  module CustomLists
    class ListRow < Refinery::Core::BaseModel
      self.table_name = 'refinery_custom_lists_list_rows'

      belongs_to :custom_list
      has_many :list_cells, dependent: :destroy

      attr_accessible :custom_list_id, :position

      validates :custom_list_id,     presence: true

      def cell_for_column(list_column)
        list_cells.detect { |list_cell| list_cell.list_column_id == list_column.id }
      end

    end
  end
end
