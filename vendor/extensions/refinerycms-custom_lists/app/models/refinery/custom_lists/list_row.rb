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

      def data_for(list_columns)
        list_columns.inject({'list_row_id' => id}) { |acc, list_column|
          unless (list_cell = list_cells.detect { |lc| lc.list_column_id == list_column.id })
            list_cell = list_cells.create(list_column_id: list_column.id)
          end
          acc.merge(list_column.title => list_cell.value)
        }
      end

    end
  end
end
