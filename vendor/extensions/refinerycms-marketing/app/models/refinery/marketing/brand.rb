module Refinery
  module Marketing
    class Brand < Refinery::Core::BaseModel
      self.table_name = 'refinery_brands'

      belongs_to :logo, :class_name => '::Refinery::Image'
      has_many :brand_shows, dependent: :destroy
      has_many :shows, through: :brand_shows

      attr_accessible :name, :website, :logo_id, :description, :position

      validates :name, presence: true, uniqueness: true

    end
  end
end
