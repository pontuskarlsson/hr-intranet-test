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
          company_code: 'CustomerCode',
          company_label: 'Customer',
          inspection_date: 'InspDate',
          inspected_by_name: 'InspectorName',
          inspection_standard: 'InspStandard',
          inspection_type: 'InspType',
          manufacturer_code: 'ManufacturerCode',
          manufacturer_label: 'Manufacturer',
          po_qty: 'OrderQty',
          po_type: 'OrderType',
          po_number: 'PO',
          result: 'Result',
          inspection_sample_size: 'SampleSize',
          product_code: 'StyleNr',
          supplier_code: 'SupplierCode',
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

        inspection.fields = payload

        set_inspected_by! data['InspectorID']
        set_company!
        set_supplier!
        set_manufacturer!

        inspection.save!

        handle_exports!(inspection, payload['exports'])
        handle_defects!(inspection, data['Defect'])
        handle_photos!(inspection, payload['files'])

        inspection.inspection_photo = inspection.inspection_photos.detect { |inspection_photo| inspection_photo.fields['key'] == 'd' }
        inspection.save!
      end

      def set_inspected_by!(inspector_email)
        if inspector_email.present?
          inspection.inspected_by ||= ::Refinery::Authentication::Devise::User.find_by email: inspector_email
        end
      end

      def set_company!
        if inspection.company_code.present? && (company = ::Refinery::Business::Company.find_by(code: inspection.company_code)).present?
          inspection.company = company

        elsif inspection.company_label.present? && (company = ::Refinery::Business::Company.find_by(name: inspection.company_label)).present?
          inspection.company = company

        else
          inspection.company = nil
        end
      end
      
      def set_manufacturer!
        if inspection.manufacturer_code.present? && (manufacturer = ::Refinery::Business::Company.find_by(code: inspection.manufacturer_code)).present?
          inspection.manufacturer = manufacturer

        elsif inspection.manufacturer_label.present? && (manufacturer = ::Refinery::Business::Company.find_by(name: inspection.manufacturer_label)).present?
          inspection.manufacturer = manufacturer

        else
          inspection.manufacturer = nil
        end
      end

      def set_supplier!
        if inspection.supplier_code.present? && (supplier = ::Refinery::Business::Company.find_by(code: inspection.supplier_code)).present?
          inspection.supplier = supplier

        elsif inspection.supplier_label.present? && (supplier = ::Refinery::Business::Company.find_by(name: inspection.supplier_label)).present?
          inspection.supplier = supplier

        else
          inspection.supplier = nil
        end
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
            image =
                begin
                  create_image!(inspection, topo_file['url'], topo_file['fileId'])
                rescue Dragonfly::Serializer::MaliciousString => e
                  # Try again
                  create_image!(inspection, topo_file['url'], topo_file['fileId'])
                end
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

      def handle_exports!(inspection, topo_exports)
        raise 'Inspection must be saved before creating a resource' unless inspection.persisted?

        @resource = Array(topo_exports).select { |te| te['type'] == 'application/pdf' }.each do |topo_export|
          begin
            inspection.resource = create_resource!(inspection, topo_export['url'], topo_export['name'])
          rescue Dragonfly::Serializer::MaliciousString => e
            # Try again, this could be caused by a timeout or something similar
            inspection.resource = create_resource!(inspection, topo_export['url'], topo_export['name'])
          end
        end
      end

      def defect_for(defect_list)
        category_code, defect_code = defect_list.split('.')

        @defect_for ||= {}
        @defect_for[defect_list] ||= ::Refinery::QualityAssurance::Defect.find_by(category_code: category_code, defect_code: defect_code)

      rescue StandardError => e
        nil
      end

      def create_image!(inspection, url, file_name)
        raise 'Inspection must be saved before creating an image' unless inspection.persisted?

        file = Tempfile.new([File.basename(file_name, File.extname(file_name)), File.extname(file_name)]).tap do |file|
          file.binmode
          file.write(open(url).read)
          file.close
        end

        file.class.class_eval { attr_accessor :original_filename }
        file.original_filename = file_name

        ::Refinery::Image.create_with_access({ image: file }, {
            Refinery::QualityAssurance::ROLE_INTERNAL => { inspection_id: inspection.id },
            Refinery::QualityAssurance::ROLE_EXTERNAL => { inspection_id: inspection.id }
        })
      end

      def create_resource!(inspection, url, file_name)
        file = Tempfile.new([File.basename(file_name, File.extname(file_name)), File.extname(file_name)]).tap do |file|
          file.binmode
          file.write(open(url).read)
          file.close
        end

        file.class.class_eval { attr_accessor :original_filename }
        file.original_filename = file_name

        resources = ::Refinery::Resource.create_resources_with_access({ file: file }, {
            Refinery::QualityAssurance::ROLE_INTERNAL => { inspection_id: inspection.id },
            Refinery::QualityAssurance::ROLE_EXTERNAL => { inspection_id: inspection.id }
        })
        resources[0]
      end

    end
  end
end
