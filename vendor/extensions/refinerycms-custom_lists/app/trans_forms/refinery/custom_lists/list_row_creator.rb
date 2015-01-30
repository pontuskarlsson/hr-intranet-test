module Refinery
  module CustomLists
    class ListRowCreator < TransForms::FormBase
      set_main_model :list_row

      attr_accessor :custom_list
      attribute :list_cells_attributes,   Hash

      validates :custom_list,   presence: true

      def list_cells
        []
      end

      transaction do
        self.list_row = custom_list.list_rows.create!

        create_cells!
      end

    private
      def create_cells!
        custom_list.list_columns.each do |list_column|
          attr = list_cells_attributes.values.detect { |h| h['list_column_id'].to_i == list_column.id }
          list_row.list_cells.create!(attr)
        end
      end

    end
  end
end
