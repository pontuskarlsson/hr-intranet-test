require 'active_support/concern'

module Refinery
  module Addons
    module ConfigureLabel
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods

        DEFAULT_SEPARATOR = ' - '

        def configure_label(*attributes)
          options = attributes.extract_options!

          options[:separator] ||= DEFAULT_SEPARATOR
          options[:find_by_field] ||= attributes.first
          options[:find_by_field_position] ||= attributes.index(options[:find_by_field])
          options[:sort] ||= :asc

          define_singleton_method(:to_source) do
            scope = options[:limit_to_scope].present? ? send(options[:limit_to_scope]) : where(nil)
            scope.order(options[:find_by_field] => options[:sort]).pluck(*attributes).map { |*attr|
              if attr[0].present? # Skip if the first attribute is blank, since +find_by_label+ cannot find it anyway.
                attr.reject(&:blank?).join options[:separator]
              end
            }.compact.to_json.html_safe
          end

          define_singleton_method(:find_by_label) do |label|
            if label.present?
              label_part = label.split(options[:separator])[options[:find_by_field_position]]

              scope = options[:limit_to_scope].present? ? send(options[:limit_to_scope]) : where(nil)
              scope.find_by options[:find_by_field] => label_part if label_part.present?
            end
          end

          define_method(:label) do
            attributes.map { |attr| send(attr) }.reject(&:blank?).join options[:separator]
          end

        end


        def configure_assign_by_label(assoc, options = {})
          options[:class_name] ||= assoc.to_s.classify

          class_eval <<-RUBY_EVAL
            def #{assoc}_label
              @#{assoc}_label ||= #{assoc}&.label
            end
  
            def #{assoc}_label=(label)
              self.#{assoc} = #{options[:class_name]}.find_by_label label
              @#{assoc}_label = label
            end
          RUBY_EVAL

        end

      end
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send(:include, Refinery::Addons::ConfigureLabel)
end
