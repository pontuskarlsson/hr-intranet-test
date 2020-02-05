ActsAsIndexed.configure do |config|

  if Rails.env.production?
    config.index_file = ['/var/app/support/aai_index']
  end

end
