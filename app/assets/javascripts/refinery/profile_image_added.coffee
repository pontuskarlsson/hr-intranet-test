root = this
root.profile_image_added = (image) ->
  image_id = $(image).attr('id').replace('image_', '')

  $('.user_profile_image').css('display', '').attr
    title: $(image).attr('title')
    alt: $(image).attr('alt')
    src: $(image).attr('data-grid') # use 'grid' size that is built into Refinery CMS (135x135#c).

  $('#user_profile_image_id').attr('value', image_id)

  $('.no-profile-image-present').remove()

#
#  current_list_item.attr('id', 'image_' + image_id).removeClass('empty')
#
#  current_list_item.appendTo($('#page_images'))
#  reset_functionality()
  console.log
    image: image
    image_id: image_id


