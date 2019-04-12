module Inspections
  class Importer

    def initialize(file, company)
      @excel = Inspections::Excel.new Spreadsheet.open(file.path)
      @company = company
    end

    def update_inspections
      @excel.each_inspection do |document_id, excel_inspection|

        next if @company.inspections.where(document_id: document_id).exists?

        inspection = @company.inspections.build document_id: document_id

        inspection.supplier_label = excel_inspection['Supplier']
        inspection.result = excel_inspection['Result']
        inspection.inspected_by_name = excel_inspection['InspectorName']
        inspection.acc_critical = excel_inspection['AccCr']
        inspection.acc_major = excel_inspection['AccMa']
        inspection.acc_minor = excel_inspection['AccMi']
        inspection.inspection_date = excel_inspection['InspDate']
        inspection.inspection_type = excel_inspection['InspType']
        inspection.inspection_standard = excel_inspection['InspStandard']
        inspection.inspection_sample_size = excel_inspection['SampleSize']
        inspection.po_type = excel_inspection['OrderType']
        inspection.product_code = excel_inspection['StyleNr']
        inspection.po_number = excel_inspection['PO']
        inspection.po_qty = excel_inspection['OrderQty']
        inspection.available_qty = excel_inspection['AvailableQty']
        inspection.product_colour_variants = excel_inspection['Color']

        inspection.save!

        excel_inspection['Defects'].each do |excel_defect|
          category_code, defect_code = excel_defect[:code].is_a?(String) ? excel_defect[:code].split('.') : []
          defect = Refinery::QualityAssurance::Defect.where(category_code: category_code, defect_code: defect_code).first
          inspection.inspection_defects.create!(
              defect_id: defect.try(:id),
              critical: excel_defect[:critical],
              major: excel_defect[:major],
              minor: excel_defect[:minor]
          )
        end
      end
    end
  end
end
