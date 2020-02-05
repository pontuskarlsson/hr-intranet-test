Refinery::Image.class_eval do

  dragonfly_accessor :image, app: :refinery_images do
    after_assign do |attachment|
      self.assign_attributes("image_mime_type" => attachment.mime_type)
    end

    after_unassign do |attachment|
      self.assign_attributes("image_mime_type" => nil)
    end
  end

  def mime_type
    image_mime_type.presence || image&.mime_type
  end

end
