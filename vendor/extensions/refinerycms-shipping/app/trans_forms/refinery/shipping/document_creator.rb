module Refinery
  module Shipping
    class DocumentCreator < ApplicationTransForm
      PROXY_ATTR = %w(document_type comments)

      set_main_model :document, proxy: { attributes: PROXY_ATTR }, class_name: '::Refinery::Shipping::Document'

      attr_accessor :shipment
      attr_accessor :file

      validates :shipment,            presence: true
      validates :document_type,       presence: true
      validates :file,                presence: true

      attr_reader :documents, :resources

      def model=(model)
        self.shipment = model
      end

      ### Form Transaction ###
      transaction do
        create_resources!

        @documents = []
        resources.each do |resource|
          @documents << @shipment.documents.create!(
              resource_id: resource.id,
              document_type: document_type,
              comments: comments
          )
        end

        self.document = @documents.first
      end

      private

      def roles_and_conditions
        {
            Refinery::Shipping::ROLE_INTERNAL => {},
            Refinery::Shipping::ROLE_EXTERNAL => { shipment_id: shipment.id },
            Refinery::Shipping::ROLE_EXTERNAL_FF => { shipment_id: shipment.id }
        }
      end

      def create_resources!
        @resources = ::Refinery::Resource.create_resources_with_access({ file: file }, roles_and_conditions)
        (@resources = @resources.select(&:valid?)).any? || (raise ::ActiveRecord::RecordNotSaved, @resources[0])
      end

    end

  end
end
