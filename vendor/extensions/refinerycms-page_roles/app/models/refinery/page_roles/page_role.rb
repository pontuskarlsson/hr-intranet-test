module Refinery
  module PageRoles
    class PageRole < Refinery::Core::BaseModel
      self.table_name = 'refinery_page_roles'

      belongs_to :page, class_name: '::Refinery::Page'
      belongs_to :role, class_name: '::Refinery::Role'

    end
  end
end
