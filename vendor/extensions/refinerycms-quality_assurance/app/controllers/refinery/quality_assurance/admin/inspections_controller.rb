module Refinery
  module QualityAssurance
    module Admin
      class InspectionsController < ::Refinery::AdminController

        crudify :'refinery/quality_assurance/inspection'

        private

        # Only allow a trusted parameter "white list" through.
        def inspection_params
          params.require(:inspection).permit(
              :company_id, :supplier_id, :supplier_label, :business_section_id, :business_product_id, :assigned_to_id,
              :resource_id, :inspected_by_id, :document_id, :result, :inspection_date, :inspection_sample_size,
              :inspection_type, :po_number, :po_type, :po_qty, :available_qty, :product_code, :product_description,
              :product_colour_variants, :acc_critical, :acc_major, :acc_minor, :total_critical, :total_major, :total_minor
          )
        end
      end
    end
  end
end
