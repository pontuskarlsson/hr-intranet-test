module Refinery
  module Brands
    class Show < Refinery::Core::BaseModel
      self.table_name = 'refinery_shows'

      belongs_to :logo, :class_name => '::Refinery::Image'
      has_many :brand_shows, dependent: :destroy
      has_many :brands, through: :brand_shows
      has_many :crawl_web_messages, dependent: :nullify, as: :sender, class_name: '::CrawlWebMessage'

      attr_accessible :name, :website, :logo_id, :description, :position, :msg_json_struct

      validates :name, presence: true, uniqueness: true

    end
  end
end
