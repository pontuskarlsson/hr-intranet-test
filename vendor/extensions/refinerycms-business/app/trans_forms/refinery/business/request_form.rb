module Refinery
  module Business
    class RequestForm < ApplicationTransForm

      DEFAULT_REQUEST_DESCRIPTION = <<~DESC
      What type of inspection do you require?
      [In-line / Final / Both In-line and Final]

      Will PP Sample be made available to inspector?
      [a / b / c]
      a) The Sample will be made available at the factory by the brand or its representative for HR attention
      b) Use factory own keep sample
      c) Brand sends to HR directly

      What suppliers / factories will the inspections take place at?
      [Company name as well as contact details and address information for first time inspections]
      DESC

      set_main_model :request, class_name: '::Refinery::Business::Request', proxy: { attributes: :all }

      attr_accessor :company, :comment

      attribute :request_date,      Date, default: proc { Date.today }
      attribute :requested_by_id,   Integer, default: proc { |f| f.current_user&.id }
      attribute :request_type,      String, default: 'inspection'
      attribute :description,       String, default: DEFAULT_REQUEST_DESCRIPTION
      attribute :file

      validates :company,     presence: true

      validate do
        if company.present?
          errors.add(:requested_by_id, :invalid) unless requested_by_id.in? company.user_ids
        end
      end

      def model=(model)
        if model.is_a?(Refinery::Business::Company)
          self.request = model.requests.build
          self.company = model
        else
          self.company = model&.company
          self.request = model
        end
      end

      transaction do
        request.attributes = request_params
        request.save!

        self.comment = request.comments.create!(
            body: description,
            comment_by: request.requested_by,
        )

        create_resources! if file.present?

        push_to_zendesk
      end

      private

      def request_params(allowed = %i(subject description requested_by_id request_type))
        attributes.slice(*allowed).merge(created_by_id: current_user.id)
      end

      def roles_and_conditions
        {
            Refinery::Business::ROLE_INTERNAL => { company_id: request.company_id },
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
        )) unless Rails.env.test?
      end

    end
  end
end
