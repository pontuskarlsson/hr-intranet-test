require 'open-uri'

module Portal
  module Topo
    class Syncer

      SYNC_ATTRIBUTES = {
          acc_critical: 'AccCr',
          acc_major: 'AccMa',
          acc_minor: 'AccMi',
#          "AQLMajor"=>2.5,
#          "AQLMinor"=>"4.0",
          available_qty: 'AvailableQty',
          product_colour_variants: 'Color',
#          "Customer"=>"BJÖRN BORG",
          inspection_date: 'InspDate',
          inspected_by_name: 'InspectorName',
          inspection_standard: 'InspStandard',
          inspection_type: 'InspType',
          po_qty: 'OrderQty',
          po_type: 'OrderType',
          po_number: 'PO',
          result: 'Result',
          inspection_sample_size: 'SampleSize',
          product_code: 'StyleNr',
          supplier_label: 'Supplier'
      }.freeze

      attr_reader :inspection, :error

      def initialize()
      end

      def run_webhook!(payload)
        data = payload['data'] || {}
        @inspection = ::Refinery::QualityAssurance::Inspection.find_or_initialize_by(document_id: payload['formId'])

        inspection.attributes = SYNC_ATTRIBUTES.each_with_object({}) { |(local, remote), acc|
          acc[local] = data[remote]
        }

        if payload['Customer'] && (match = /(^[0-9]{3}[0-9]*)/.match(payload['Customer'])).present? &&
            (company = ::Refinery::Business::Company.find_by(code: match[1].rjust(5, '0'))).present?
          inspection.company = company
        elsif (company = ::Refinery::Business::Company.find_by(name: payload['Customer'])).present?
          inspection.company = company
        else
          inspection.company_label = payload['Customer']
        end

        inspection.fields = payload

        inspection.save!

        handle_defects!(inspection, data['Defect'])

        handle_photos!(inspection, payload['files'])

        inspection.inspection_photo = inspection.inspection_photos.detect { |inspection_photo| inspection_photo.fields['key'] == 'd' }
        inspection.save!
      end

      def handle_defects!(inspection, topo_defects)
        @inspection_defects = Array(topo_defects).map do |topo_defect|
          inspection_defect =
              if (defect = defect_for topo_defect['Defectlist']).present?
                inspection.inspection_defects.find_or_initialize_by(defect_id: defect.id)
              else
                inspection.inspection_defects.find_or_initialize_by(
                    defect_id: nil,
                    defect_label: topo_defect['Defectlist']
                )
              end

          inspection_defect.critical = topo_defect['Critical'] || 0
          inspection_defect.major = topo_defect['Major'] || 0
          inspection_defect.minor = topo_defect['Minor'] || 0
          inspection_defect.can_fix = topo_defect['CanFix']

          inspection_defect.save!

          inspection_defect
        end

        inspection.inspection_defects.where.not(id: @inspection_defects.map(&:id)).each(&:destroy)
      end

      def handle_photos!(inspection, topo_files)
        @inspection_photos = Array(topo_files).select { |tf| tf['property'] == 'src' }.map do |topo_file|
          if (inspection_photo = inspection.inspection_photos.find_by(file_id: topo_file['fileId'])).present?
            inspection_photo

          else
            image = create_image!(inspection, topo_file['url'], topo_file['fileId'])
            inspection_photo = inspection.inspection_photos.build(
                file_id: topo_file['fileId'],
                image_id:image.id
            )

            if topo_file['key'] && (match = /^cj\.([0-9]+)\./.match(topo_file['key'])).present?
              index = match[1].to_i
              inspection_photo.inspection_defect = @inspection_defects[index]
            end

            inspection_photo.fields = topo_file

            inspection_photo.save!

            inspection_photo
          end
        end

        inspection.inspection_photos.where.not(id: @inspection_photos.map(&:id)).each(&:destroy)
      end

      def defect_for(defect_list)
        category_code, defect_code = defect_list.split('.')

        @defect_for ||= {}
        @defect_for[defect_list] ||= ::Refinery::QualityAssurance::Defect.find_by(category_code: category_code, defect_code: defect_code)

      rescue StandardError => e
        nil
      end

      def create_image!(inspection, url, file_name)
        file = Tempfile.new([File.basename(file_name, File.extname(file_name)), File.extname(file_name)]).tap do |file|
          file.binmode
          file.write(open(url).read)
          file.close
        end

        file.class.class_eval { attr_accessor :original_filename }
        file.original_filename = file_name

        ::Refinery::Image.create_with_access({ image: file }, {
            Refinery::QualityAssurance::ROLE_INTERNAL => {},
            Refinery::QualityAssurance::ROLE_EXTERNAL => { inspection_id: inspection.id }
        })
      end

    end
  end
end
