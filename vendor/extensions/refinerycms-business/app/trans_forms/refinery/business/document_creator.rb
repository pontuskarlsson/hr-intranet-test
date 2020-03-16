module Refinery
  module Business
    class DocumentCreator < ApplicationTransForm
      PROXY_ATTR = %w(document_type comments)

      set_main_model :document, proxy: { attributes: PROXY_ATTR }, class_name: '::Refinery::Shipping::Document'

      attribute :request_id,          Integer

      attr_accessor :company
      attr_accessor :file

      validates :company,             presence: true
      validates :document_type,       presence: true
      validates :file,                presence: true

      attr_reader :documents, :resources

      def model=(model)
        if model.is_a? ::Refinery::Business::Request
          self.request_id = model.id
          self.company = model.company
        else
          self.company = model
        end
      end

      ### Form Transaction ###
      transaction do
        create_resources!

        @documents = []
        resources.each do |resource|
          @documents << @company.documents.create!(
              resource_id: resource.id,
              document_type: document_type,
              comments: comments,
              request_id: request_id
          )
        end

        self.document = @documents.first
      end

      private

      def roles_and_conditions
        {
            Refinery::Business::ROLE_INTERNAL => {},
            Refinery::Business::ROLE_EXTERNAL => { company_id: company.id }
        }
      end

      def create_resources!
        @resources = ::Refinery::Resource.create_resources_with_access({ file: file }, roles_and_conditions)
        (@resources = @resources.select(&:valid?)).any? || (raise ::ActiveRecord::RecordNotSaved, @resources[0])
      end

    end

  end
end
