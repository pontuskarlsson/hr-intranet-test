class ReportsController < ApplicationController
  include Refinery::PageRoles::AuthController

  set_page Refinery::QualityAssurance::PAGE_INSPECTIONS_URL

  allow_page_roles Refinery::QualityAssurance::ROLE_EXTERNAL, only: [:inspections]
  allow_page_roles Refinery::QualityAssurance::ROLE_INTERNAL, only: [:inspections]

  allow_page_roles Refinery::Business::ROLE_INTERNAL_FINANCE, only: [:statement]

  before_action :find_inspections,  only: [:inspections]
  before_action :find_invoice,      only: [:statement]

  def inspections
    @title = 'QA Report: Inspections'

    @inline_inspections = @inspections.inline
    @inline_inspection_defects ||= @inline_inspections.includes(inspection_defects: :defect).each_with_object({}) { |inspection, acc|
      inspection.inspection_defects.each do |inspection_defect|
        if inspection_defect.defect.present?
          acc[inspection_defect.defect] ||= []
          acc[inspection_defect.defect] << [inspection, inspection_defect]
        end
      end
    }

    @inspections = @inspections.all_final

    respond_to do |format|
      format.pdf { render pdf: "Inspections #{DateTime.now.strftime('%d, %M, %Y')}", window_status: "FLAG_FOR_PDF" }
    end
  end

  private

  def inspections_scope
    @inspections ||=
        if page_role?(Refinery::QualityAssurance::ROLE_INTERNAL) or page_role?(Refinery::QualityAssurance::ROLE_INTERNAL_MANAGER)
          Refinery::QualityAssurance::Inspection.where(nil)
        elsif page_role? Refinery::QualityAssurance::ROLE_INSPECTOR
          Refinery::QualityAssurance::Inspection.inspected_by(current_refinery_user)
        elsif page_role? Refinery::QualityAssurance::ROLE_EXTERNAL
          Refinery::QualityAssurance::Inspection.for_companies(current_refinery_user.companies)
        else
          Refinery::QualityAssurance::Inspection.none
        end
  end

  def find_inspections
    @inspections = inspections_scope.where(inspections_filter_params).where(id: params[:id])
  rescue ::ActiveRecord::RecordNotFound
    error_404
  end

  def find_invoice
    @invoice = Refinery::Business::Invoice.find params[:id]
  rescue ::ActiveRecord::RecordNotFound
    error_404
  end

  def inspections_filter_params
    params.permit([:company_id, :manufacturer_id, :supplier_id, :business_section_id, :business_product_id])
  end

end
