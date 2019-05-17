# encoding: utf-8
Refinery::Resources.configure do |config|
  # Configures the maximum allowed upload size (in bytes) for a file upload
  # config.max_file_size = 52428800

  # Configure how many resources per page should be displayed when a dialog is presented that contains resources
  # config.pages_per_dialog = 12

  # Configure how many resources per page should be displayed in the list of resources in the admin area
  # config.pages_per_admin_index = 20

  # Configure S3 (you can also use ENV for this)
  # The s3_backend setting by default defers to the core setting for this but can be set just for resources.
  # config.s3_backend = Refinery::Core.s3_backend
  # config.s3_bucket_name = ENV['S3_BUCKET']
  # config.s3_access_key_id = ENV['S3_KEY']
  # config.s3_secret_access_key = ENV['S3_SECRET']
  # config.s3_region = ENV['S3_REGION']

  # Configure Dragonfly
  # This is where in the middleware stack to insert the Dragonfly middleware
  # config.dragonfly_insert_before = "ActionDispatch::Callbacks"
  # config.dragonfly_secret = "e4c07b16cc3e896773fc03927e844adf8bd30091d3e4cee0"
  # config.dragonfly_url_format = "/system/resources/:job/:basename.:format"
  # config.dragonfly_url_host = ""
  # config.datastore_root_path = "/vagrant/hr_intranet/public/system/refinery/resources"
  # config.content_disposition = :attachment

  # Configure Dragonfly custom storage backend
  # The custom_backend setting by default defers to the core setting for this but can be set just for resources.
  # config.custom_backend_class = nil
  # config.custom_backend_opts = {}

end


Dragonfly::S3DataStore.class_eval do
  def initialize(opts={})
    @bucket_name = opts[:bucket_name]
    @access_key_id = opts[:access_key_id]
    @secret_access_key = opts[:secret_access_key]
    @region = opts[:region]
    @storage_headers = opts[:storage_headers] || {'x-amz-acl' => 'private'}
    @url_scheme = opts[:url_scheme] || 'http'
    @url_host = opts[:url_host]
    @use_iam_profile = opts[:use_iam_profile]
    @root_path = opts[:root_path]
    @fog_storage_options = opts[:fog_storage_options] || {}
  end
end
