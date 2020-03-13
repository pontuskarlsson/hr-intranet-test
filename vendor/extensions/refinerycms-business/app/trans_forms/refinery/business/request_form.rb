module Refinery
  module Business
    class RequestForm < ApplicationTransForm
      set_main_model :request, class_name: '::Refinery::Business::Request', proxy: { attributes: :all }

      attr_accessor :comment

      attribute :request_date,      Date, default: proc { Date.today }
      attribute :company_label,     String
      attribute :file

      validates :company_label,      presence: true

      transaction do
        self.request = ::Refinery::Business::Request.create!(request_params)
        self.comment = request.comments.create!(
            body: description,
            comment_by: request.requested_by,
        )

        create_resources! if file.present?

        push_to_zendesk
      end

      private

      def request_params(allowed = %i(subject description request_type company_label))
        attributes.slice(*allowed).merge(created_by_id: current_user.id, requested_by_id: current_user.id)
      end

      def roles_and_conditions
        {
            Refinery::Business::ROLE_INTERNAL => {},
            Refinery::Business::ROLE_EXTERNAL => { company_id: request.company_id }
        }
      end

      def create_resources!
        @resources = ::Refinery::Resource.create_resources_with_access({ file: file }, roles_and_conditions)
        (@resources = @resources.select(&:valid?)).any? || (raise ::ActiveRecord::RecordNotSaved, @resources[0])

        @documents = []
        @resources.each do |resource|
          @documents << request.company.documents.create!(
              resource_id: resource.id,
              request_id: request.id,
              document_type: 'other',
              comments: "Uploaded together with Request #{request.code}"
          )
        end
      end

      def push_to_zendesk
        Delayed::Job.enqueue(::Refinery::Addons::Zendesk::CreateTicketJob.new(
            request.id,
            request.class.name,
            comment.id
        ))
      end

    end
  end
end
