module Refinery
  module CustomLists
    class ListColumn < Refinery::Core::BaseModel
      COLUMN_TYPES = %w(Text Number)

      self.table_name = 'refinery_custom_lists_list_columns'

      belongs_to :custom_list
      has_many :list_cells,   dependent: :destroy

      attr_accessible :custom_list_id, :title, :column_type, :position

      validates :custom_list_id,  presence: true
      validates :title,           presence: true, uniqueness: { scope: :custom_list_id }
      validates :column_type,     inclusion: COLUMN_TYPES

    end
  end
end
