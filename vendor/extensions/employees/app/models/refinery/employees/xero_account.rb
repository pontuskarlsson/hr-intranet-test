module Refinery
  module Employees
    class XeroAccount < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_accounts'

      has_many :xero_line_items, dependent: :nullify

      attr_accessible :code, :guid, :name

      validates :guid,    presence: true, uniqueness: true
      validates :code,    presence: true, uniqueness: true
      validates :name,    presence: true

      def code_and_name
        [code, name].reject(&:blank?).join(' - ')
      end

    end
  end
end
