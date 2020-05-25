module Refinery
  module QualityAssurance
    class PossibleCausesForm < ApplicationTransForm

      PROXY_ATTR = %w()

      set_main_model :defect, proxy: { attributes: PROXY_ATTR }, class_name: '::Refinery::QualityAssurance::Defect'

      attribute :possible_causes_attributes,  Hash

      delegate :persisted?, :possible_causes, to: :defect

      validates :defect,              presence: true

      def model=(model)
        self.defect = model
      end

      transaction do
        each_nested_hash_for possible_causes_attributes do |attr|
          update_possible_cause! attr
        end
      end

      private

      def update_possible_cause!(attr)
        if attr['id'].present?
          possible_cause = find_from! defect.possible_causes, attr['id']
          if attr['_destroy'] == '1'
            possible_cause.destroy!
          end

        elsif attr['cause_label'].present?
          cause = Cause.find_by_label! attr['cause_label']
          defect.possible_causes.create!(cause: cause)

        elsif attr['cause_cause_name'].present?
          cause = Cause.create!(
              category_code: attr['cause_category_code'],
              category_name: attr['cause_category_name'],
              cause_code: attr['cause_cause_code'],
              cause_name: attr['cause_cause_name'],
              description: attr['cause_description'],
          )
          defect.possible_causes.create!(cause: cause)
        end
      end

    end
  end
end
