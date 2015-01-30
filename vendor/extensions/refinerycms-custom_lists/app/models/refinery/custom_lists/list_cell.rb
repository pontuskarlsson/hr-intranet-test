module Refinery
  module CustomLists
    class ListCell < Refinery::Core::BaseModel
      self.table_name = 'refinery_custom_lists_list_cells'

      belongs_to :list_row
      belongs_to :list_column

      attr_accessible :list_row_id, :list_column_id, :value

      validates :list_row_id,     presence: true
      validates :list_column_id,  presence: true, uniqueness: { scope: :list_row_id }

    end
  end
end
