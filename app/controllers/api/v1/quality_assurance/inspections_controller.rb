class Api::V1::QualityAssurance::InspectionsController < Api::V1::ApiController
  before_action :find_inspections,  only: %i(index)

  def index
    respond_with @inspections
  end

  private

  def scope
    @scope ||=
        if current_resource_owner.has_role?(::Refinery::QualityAssurance::ROLE_INTERNAL) or
            current_resource_owner.has_role?(::Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER)
          ::Refinery::QualityAssurance::Inspection.where(nil)

        elsif current_resource_owner.has_role?(::Refinery::QualityAssurance::ROLE_INSPECTOR)
          ::Refinery::QualityAssurance::Inspection.inspected_by(current_resource_owner)

        elsif current_resource_owner.has_role?(::Refinery::QualityAssurance::ROLE_EXTERNAL)
          ::Refinery::QualityAssurance::Inspection.for_companies(current_resource_owner.companies)

        else
          ::Refinery::QualityAssurance::Inspection.where('1=0')
        end
  end

  def find_inspections
    @inspections = scope.where(filter_params).order(inspection_date: :desc).limit(10)
  end

  def filter_params
    params.permit([:company_id, :manufacturer_id, :supplier_id, :business_section_id, :business_product_id]).to_h
  end

end
