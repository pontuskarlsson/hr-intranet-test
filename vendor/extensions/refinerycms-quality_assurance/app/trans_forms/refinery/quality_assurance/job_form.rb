module Refinery
  module QualityAssurance
    class JobForm < ApplicationTransForm

      set_main_model :job, class_name: '::Refinery::QualityAssurance::Job', proxy: { attributes: %w(status) }

      attr_accessor :company

      attribute :project_label,               String, default: proc { |f| f.job&.project_label }
      attribute :billable_label,              String, default: proc { |f| f.job&.billable_label }
      attribute :product_category,            String, default: proc { |f| f.job&.product_category }
      attribute :complexity,                  String, default: proc { |f| f.job&.complexity }

      attribute :purchase_orders_attributes,  Hash
      attribute :products_attributes,         Hash

      validates :company,     presence: true

      def model=(model)
        if model.is_a?(Refinery::Business::Company)
          self.job = model.jobs.build
          self.company = model
        else
          self.company = model&.company
          self.job = model
        end
      end

      transaction do
        job.attributes = job_params

        job.purchase_orders_attributes = purchase_orders_attributes if purchase_orders_attributes.any?
        job.products_attributes = products_attributes if products_attributes.any?

        job.save!
      end

      private

      def job_params(allowed = %i(status project_label billable_label product_category complexity))
        attributes.slice(*allowed)
      end

    end
  end
end
