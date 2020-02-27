module Refinery
  module Marketing
    class LandingPage < Refinery::Core::BaseModel
      self.table_name = 'refinery_marketing_landing_pages'

      belongs_to :campaign,       optional: true
      belongs_to :page,           class_name: '::Refinery::Page',
                                  optional: true

      validates :title,           presence: true
      validates :slug,            presence: true, uniqueness: true

      before_create do
        self.page = ::Refinery::Page.create(
            :title => title,
            :link_url => slug,
            :deletable => false,
            :menu_match => "^#{slug}(\/|\/.+?|)$",
            :show_in_menu => false,
            :view_template => 'sections',
            :layout_template => 'public'
        )

        throw :abort unless page.persisted?

        ::Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
          page.parts.create(:title => default_page_part[:title], :slug => default_page_part[:slug], :body => nil, :position => index)
        end
      end

    end
  end
end
