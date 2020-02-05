Refinery::Resource.class_eval do

  dragonfly_accessor :file, app: :refinery_resources do
    after_assign do |attachment|
      self.assign_attributes("file_mime_type" => attachment.mime_type)
    end

    after_unassign do
      self.assign_attributes("file_mime_type" => nil)
    end
  end

  def mime_type
    file_mime_type.presence || file&.mime_type
  end

end
