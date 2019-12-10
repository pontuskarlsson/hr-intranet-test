module Refinery
  module Marketing
    class Show < Refinery::Core::BaseModel
      self.table_name = 'refinery_shows'

      belongs_to :logo, :class_name => '::Refinery::Image', optional: true
      has_many :brand_shows, dependent: :destroy
      has_many :marketing, through: :brand_shows

      #attr_accessible :name, :website, :logo_id, :description, :position, :msg_json_struct

      validates :name, presence: true, uniqueness: true

    end
  end
end
