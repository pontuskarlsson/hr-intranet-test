module Refinery
  module Employees
    class XeroAccount < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_accounts'

      has_many :xero_line_items, dependent: :nullify

      attr_accessible :featured, :when_to_use
      attr_accessible :code, :guid, :name, as: :sync_update

      validates :guid,    presence: true, uniqueness: true
      validates :code,    presence: true, uniqueness: { scope: :inactive }, unless: :inactive
      validates :name,    presence: true

      def code_and_name
        [code, name].reject(&:blank?).join(' - ')
      end

      class << self
        def featured
          where(featured: true)
        end
      end

    end
  end
end
