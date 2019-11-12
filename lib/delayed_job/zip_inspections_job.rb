class ZipInspectionsJob < Struct.new(:resource_id, :inspection_ids)

  def perform
    ActiveRecord::Base.transaction do
      inspections = Refinery::QualityAssurance::Inspection.find(inspection_ids)
      resource = Refinery::Resource.find resource_id

      tempfile = Tempfile.new('Inspections Archive')

      tempfile.class.class_eval { attr_accessor :original_filename }
      tempfile.original_filename = 'Inspections Archive.zip'
      tempfiles = []

      Zip::File.open(tempfile.path, Zip::File::CREATE) do |zipfile|
        inspections.each do |inspection|
          if inspection.resource.present?
            # Two arguments:
            # - The name of the file as it will appear in the archive
            # - The original file, including the path to find it
            tempfiles << tmp_report = Tempfile.new
            inspection.resource.file.to_file(tmp_report.path)

            # Sometimes the length of a filename gets shortened and results in
            # the distinguishing part of it being removed. So we must be aware
            # of potential name conflicts and handle it.
            basename = File.basename(inspection.resource.file_name)
            extname = File.extname(inspection.resource.file_name)
            idx = 1
            loop do
              begin
                zipfile.add("#{basename}.#{extname}", tmp_report.path)
                break
              rescue ::Zip::EntryExistsError => e
                idx += 1
                basename = basename[0..87] << "_#{idx}"
              end
            end
          end
        end
        #zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
      end
      resource.file = tempfile
      resource.save!
    end
  rescue StandardError => e
    ErrorMailer.error_email(e).deliver
  end

end
