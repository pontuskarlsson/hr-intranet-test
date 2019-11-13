require 'virtus'
require 'active_support'
require 'active_model'

module TransForms
  class FormBase
    include Virtus.model

    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    include TransForms::Callbacks

    # Defines the class methods +before_save+, +around_save+ and +after_save+.
    define_model_callbacks :save

    def save
      if valid?
        run_callbacks :save do
          run_transaction
        end
      else
        false
      end
    end

    def save!
      save || (raise ActiveRecord::RecordNotSaved.new(self))
    end

    # ActiveModel support.
    # Note that these methods will be overwritten if the +proxy+ option
    # is enabled in the call to +set_main_model+
    def persisted?; false end
    def to_key; nil end

  protected
    def self.transaction(&block)
      class_attribute :_transaction
      self._transaction = block
    end

    def run_transaction
      ActiveRecord::Base.transaction do
        instance_eval &_transaction
        true
      end
    rescue ActiveRecord::ActiveRecordError => e
      # Triggers callback
      after_save_on_error_callback e
      false
    end

    # A method to to use when you want to redirect any errors raised to a
    # specific attribute. It requires a block and any ActiveRecordErrors
    # that are raised within this block will be assigned to the Form Models
    # FormErrors instance for the key specified by +attr+.
    #
    #   class ArticleCreator < ApplicationTransForm
    #     attribute :author_name
    #     ...
    #
    #     transaction do
    #       all_errors_to(:author_name) do
    #         # If this following statement raises an ActiveRecordError, then
    #         # that error message will be stored on the attribute :author_name
    #         Author.create!(name: author_name)
    #       end
    #
    #       ...
    #     end
    #   end
    #
    def all_errors_to(attr)
      raise 'No block given' unless block_given?
      yield
    rescue ActiveRecord::ActiveRecordError => e
      errors[attr] = e.message
      raise e
    end

  end
end
