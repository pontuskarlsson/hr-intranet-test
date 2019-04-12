module Inspections
  class Excel

    COLUMNS = [
        "DocumentId",
        "DocumentId All",
        "Submitted (UTC)",
        "Submitted Month",
        "Tags",
        "Account Link",
        "Result",
        "InspectorName",
        "AccMa",
        "AccMi",
        "InspDate",
        "TotalCritical",
        "TotalMajor",
        "TotalMinor",
        "InspType",
        "Customer",
        "AQLMajor",
        "AQLMinor",
        "AccCr",
        "InspStandard",
        "SampleSize",
        "SampleSizeManual",
        "Supplier",
        "OrderType",
        "StyleNr",
        "PO",
        "OrderQty",
        "OverUnderShipment",
        "AvailableQty",
        "Color",
        "Defect.Defectlist",
        "Defect.Critical",
        "Defect.Major",
        "Defect.Minor"
    ]

    ALLOW_UPDATES = [

    ]

    INSPECTIONS_WORKSHEET = 'Inspection Report'

    def initialize(book)
      @book = book
      @sheet = book.worksheet(INSPECTIONS_WORKSHEET)
    end

    def self.blank
      workbook = Spreadsheet::Workbook.new
      workbook.create_worksheet(name: INSPECTIONS_WORKSHEET)
      new workbook
    end

    def each_inspection(&block)
      inspections = @sheet.rows[1..-1].each_with_object({}) do |row, acc|
        doc_id = row[COLUMNS.index("DocumentId All")]

        if acc[doc_id].nil?
          acc[doc_id] = COLUMNS.each_with_index.each_with_object({}) { |(col, i), acc2|
            acc2[col] = row[i]
          }
          acc[doc_id]["Defects"] = []
        end

        acc[doc_id]["Defects"] << {
            code: row[COLUMNS.index("Defect.Defectlist")] || 0,
            critical: row[COLUMNS.index("Defect.Critical")] || 0,
            major: row[COLUMNS.index("Defect.Major")] || 0,
            minor: row[COLUMNS.index("Defect.Minor")] || 0,
        }
      end

      inspections.each_pair(&block)
    end

  end
end
