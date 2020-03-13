require 'active_support/concern'

module Refinery
  module Addons
    module HasComments
      extend ActiveSupport::Concern

      module ClassMethods

        def has_comments
          has_many :comments, as: :commentable, class_name: '::Refinery::Addons::Comment', dependent: :destroy

          serialize :zendesk_meta, Hash

          validates :zendesk_id, uniqueness: true, allow_nil: true
        end

      end
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send(:include, Refinery::Addons::HasComments)
end
