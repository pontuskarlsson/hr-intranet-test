require 'active_support/concern'

module Portal
  module Wizard
    module ActiveRecord
      extend ActiveSupport::Concern

      module ClassMethods

        def has_wizard(*args)
          options = args.extract_options!
          # Move to lib
          define_method(:wizard_steps) do
            options[:steps]
          end

          define_method(:wizard_creatable_at) do
            options[:creatable_at] || wizard_steps.last
          end

          attr_writer :wizard_current_step
          attr_accessor :wizard_saved

          send :include, Portal::Wizard::ActiveRecord::WizardInstanceMethods
        end

      end

      module WizardInstanceMethods

        def wizard_current_step
          @wizard_current_step ||= wizard_steps.first
        end

        def wizard_next_step
          self.wizard_current_step = wizard_steps[wizard_steps.index(wizard_current_step)+1]
        end

        def wizard_previous_step
          self.wizard_current_step = wizard_steps[wizard_steps.index(wizard_current_step)-1]
        end

        def wizard_first_step?
          self.wizard_current_step == wizard_steps.first
        end

        def wizard_last_step?
          self.wizard_current_step == wizard_steps.last
        end

        def wizard_step_number
          wizard_steps.index(wizard_current_step)
        end

        def wizard_total_steps
          wizard_steps.length
        end

        def wizard_creatable?
          wizard_step_number >= wizard_steps.index(wizard_creatable_at.to_s)
        end

        def wizard_save
          self.wizard_saved = save
        end

        # Method that can be used to determine if a validation should run
        # or not. If +@wizard_current_step+ is not set it means that the
        # wizard is not being used. In that case the method return +true+
        # because all validations should run.
        # But if +@wizard_current_step+ is not nil then it checks whether
        # the current step matches the step send to the method. If it does
        # not then the method returns false to avoid running that specific
        # validation.
        #
        # === Examples
        #
        #   class Person
        #     validates_presence_of :address, :if => Proc.new { |p| p.wizard_validates?("address_step") }
        #
        def wizard_validates?(step)
          @wizard_current_step.nil? || @wizard_current_step == step
        end

      end

    end
  end
end
