module Refinery
  module ResourceAuthorizations
    include ActiveSupport::Configurable

    config_accessor :s3_storage_headers

    self.s3_storage_headers = {'x-amz-acl' => 'private'}
  end
end
