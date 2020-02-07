require 'active_support/concern'

module Portal
  module Wizard
    module ActionController
      extend ActiveSupport::Concern

      module ClassMethods

        def has_wizard(model_name, *args)
          model_name = model_name.to_s
          options = args.extract_options!
          options[:new_session_at] ||= :new
          options[:build_instance_at] ||= :create
          build_syntax = options[:through].present? ? "@#{options[:through]}.#{model_name.pluralize}.build" : "#{model_name.classify}.new"

          class_attribute :wizard_default_attributes, instance_writer: false
          self.wizard_default_attributes = options[:default_attributes] || {}

          before_action :new_wizard_session, :only => options[:new_session_at]
          before_action :build_wizard_object, :only => options[:build_instance_at]

          class_eval %(
            def new_wizard_session
              clear_session!

              @#{model_name} = #{build_syntax}
              if wizard_default_attributes.present?
                @#{model_name}.attributes = instance_eval &wizard_default_attributes
              end
              session[:#{model_name}_step] = @#{model_name}.wizard_current_step
            end

            def build_wizard_object
              @#{model_name} = #{build_syntax}(wizard_#{model_name}_params)
              if wizard_default_attributes.present?
                @#{model_name}.attributes = instance_eval &wizard_default_attributes
              end

              @#{model_name}.wizard_current_step = requested_step || session[:#{model_name}_step]
              if requested_step
                # Manually requested specified step, do nothing else
              elsif params[:wizard_back]
                @#{model_name}.wizard_previous_step
              elsif @#{model_name}.valid?
                if params[:wizard_create] || @#{model_name}.wizard_last_step?
                  if @#{model_name}.wizard_save
                    clear_session!
                  end
                else
                  @#{model_name}.wizard_next_step
                end
              end
              session[:#{model_name}_step] = @#{model_name}.wizard_current_step
            end

            def wizard_#{model_name}_params
              @wizard_params ||= (params[:#{model_name}] ? params[:#{model_name}].to_unsafe_hash : Hash.new).tap do |attributes|
                if params[:wizard_session_id] && params[:wizard_session_id] == wizard_session_id
                  attributes.reverse_merge!(session[:#{model_name}_params])
                else
                  clear_session!(true)
                end

                session[:#{model_name}_params] = attributes
              end
            end

            def requested_step
              params[:#{model_name}][:wizard_current_step]
            rescue NoMethodError
              nil
            end

            def clear_session!(force = false)
              if force
                reset_session
              else
                session.delete(:wizard_#{model_name}_session_id)
                session.delete(:#{model_name}_params)
              end
            end

            def wizard_session_id
              session[:wizard_#{model_name}_session_id] ||= SecureRandom.hex
            end

            helper_method :wizard_session_id
          ), __FILE__, __LINE__

          protected :new_wizard_session, :build_wizard_object
        end

      end

    end
  end
end
