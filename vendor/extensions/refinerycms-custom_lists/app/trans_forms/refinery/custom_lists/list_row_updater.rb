module Refinery
  module CustomLists
    class ListRowUpdater < TransForms::FormBase
      set_main_model :list_row

      attribute :list_cells_attributes,   Hash

      validates :list_row,   presence: true

      def list_cells
        []
      end

      transaction do
        list_row.custom_list.list_columns.each do |list_column|
          list_cell = list_row.list_cells.detect { |list_cell| list_cell.list_column_id == list_column.id } || list_row.list_cells.build(list_column_id: list_column.id)
          attr = list_cells_attributes.values.detect { |h| h['list_column_id'].to_i == list_column.id } || {}
          list_cell.attributes = attr
          list_cell.save!
        end
      end

    end
  end
end
