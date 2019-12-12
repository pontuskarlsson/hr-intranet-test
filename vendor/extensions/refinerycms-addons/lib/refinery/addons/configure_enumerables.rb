require 'active_support/concern'

module Refinery
  module Addons
    module ConfigureEnumerables
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods
        def configure_enumerables(attribute, values, options = {})

          values.each do |value|
            define_method :"#{attribute}_is_#{value.downcase.gsub('-', '_')}?" do
              send(attribute) == value
            end
          end

          define_method :"display_#{attribute}" do
            if send(attribute).present?
              ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.#{attribute.to_s.pluralize}.#{send(attribute).downcase}"
            end
          end

          define_singleton_method :"#{attribute}_options" do
            values.reduce(
                [[::I18n.t("refinery.please_select"), { disabled: true }]]
            ) { |acc, k| acc << [::I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{attribute.to_s.pluralize}.#{k.downcase}"),k] }
          end

        end
      end
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send(:include, Refinery::Addons::ConfigureEnumerables)
end
