ActsAsIndexed.configure do |config|

  if Rails.env.production?
    config.file_index = ['/var/app/support/aai_index']
  end

end
