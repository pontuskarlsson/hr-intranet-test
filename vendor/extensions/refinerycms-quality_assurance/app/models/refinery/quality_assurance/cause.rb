module Refinery
  module QualityAssurance
    class Cause < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_causes'

      has_many :possible_causes,      dependent: :destroy
      has_many :defects,              through: :possible_causes

      has_many :identified_causes,    dependent: :destroy
      has_many :inspection_defects,   through: :identified_causes

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:category_code, :category_name, :cause_code, :cause_name, :code]

      configure_label :code, :category_name, :cause_name

      responds_to_data_tables :id, :category_code, :category_name, :cause_code, :cause_name, :code

      validates :cause_code,        uniqueness: { scope: :category_code },
                                    allow_blank: true
      validates :cause_name,        presence: true

      validate do
        # Must have either both +cause_code+ and +category_code+ or neither
        if cause_code.present? or category_code.present?
          errors.add(:cause_code, :missing) unless cause_code.present?
          errors.add(:category_code, :missing) unless category_code.present?
        end

        if category_code.present?
          errors.add(:category_name, :missing) unless category_name.present?
        end
      end

      before_validation do
        set_code! if code.blank?
      end

      scope :similar_to, -> (cause) { where.not(id: cause.id).where(category_code: cause.category_code) }

      def self.for_user_roles(user, role_titles = nil)
        where(nil) # No restrictions at this time
      end

      def self.for_selected_company(selected_company)
        where(nil) # No restrictions at this time
      end

      # Overriding label for different separators
      def label
        "#{code} #{title}"
      end

      def title
        "#{category_name} - #{cause_name}"
      end

      def set_code!
        self.code = [category_code, cause_code].join '.'
      end

    end
  end
end
