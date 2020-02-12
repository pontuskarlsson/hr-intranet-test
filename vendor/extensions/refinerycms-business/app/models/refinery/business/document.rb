module Refinery
  module Business
    class Document < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_documents'

      TYPES = %w(other contract)

      attr_accessor :file # For form accessor upon creation

      #serialize :meta, Hash

      belongs_to :company
      belongs_to :resource

      has_many :plans, dependent: :nullify

      configure_enumerables :document_type, TYPES

      delegate :file_name, to: :resource, prefix: true, allow_nil: true

      validates :company_id,            presence: true
      validates :resource_id,           presence: true, uniqueness: true
      validates :document_type,         inclusion: TYPES

    end
  end
end
