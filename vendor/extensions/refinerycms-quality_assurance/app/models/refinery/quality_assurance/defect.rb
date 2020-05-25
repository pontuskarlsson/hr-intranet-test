module Refinery
  module QualityAssurance
    class Defect < Refinery::Core::BaseModel
      self.table_name = 'refinery_quality_assurance_defects'

      has_many :possible_causes,    dependent: :destroy
      has_many :causes,             through: :possible_causes

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]
      acts_as_indexed :fields => [:category_code, :category_name, :defect_code, :defect_name, :code]

      configure_label :code, :category_name, :defect_name

      responds_to_data_tables :id, :code, :category_code, :category_name, :defect_code, :defect_name

      validates :category_code,     presence: true
      validates :category_name,     presence: true
      validates :defect_code,       presence: true, uniqueness: { scope: :category_code }
      validates :defect_name,       presence: true

      before_validation do
        set_code! if code.blank?
      end

      scope :similar_to, -> (defect) { where.not(id: defect.id).where(category_code: defect.category_code) }

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
        "#{category_name} - #{defect_name}"
      end

      def set_code!
        self.code = [category_code, defect_code].join '.'
      end

    end
  end
end
