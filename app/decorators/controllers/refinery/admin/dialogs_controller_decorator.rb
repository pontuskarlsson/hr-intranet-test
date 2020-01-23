Refinery::Admin::DialogsController.class_eval do

  def find_iframe_src
    if @dialog_type == 'image'
      @iframe_src = refinery.insert_admin_images_path(
          # Modification: Added conditions parameter to url, to avoid loading non-public images
          url_params.merge(modal: true, conditions: 'authorizations_access,nil')
      )
    elsif @dialog_type == 'link'
      @iframe_src = refinery.link_to_admin_pages_dialogs_path url_params
    end
  end

end
