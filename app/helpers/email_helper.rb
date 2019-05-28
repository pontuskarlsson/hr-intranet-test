module EmailHelper

  def dragonfly_image_tag(image, **options)
    attachments[image.name] ||= image.thumb('100x100#').data
    image_tag attachments[image.name].url, **options
  end

  def asset_image_tag(image_path, **options)
    attachments[image_path] ||= File.read(Rails.root.join("app/assets/images/#{image_path}"))
    image_tag attachments[image_path].url, **options
  end

end
