require 'active_support/concern'

module Refinery
  module Addons
    module DisplayDecorators
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods

        def display_date_for(*fields)
          options = fields.extract_options!
          options[:default_value] ||= '&nbsp;'

          fields.each do |field|
            class_eval <<-RUBY_EVAL
              def display_#{field}(format = '%e %b %Y')
                if #{field}.present?
                  #{field}.strftime(format)
                else
                  '#{options[:default_value]}'.html_safe
                end
              end
            RUBY_EVAL
          end

        end

      end
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send(:include, Refinery::Addons::DisplayDecorators)
end
