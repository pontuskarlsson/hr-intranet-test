# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Adding a default Page for the MyProfiles controller
url = '/my_profile'
if defined?(Refinery::Page) && Refinery::Page.where(:link_url => url).empty?
  page = Refinery::Page.create(
      :title => 'My Profile',
      :link_url => url,
      :deletable => false,
      :menu_match => "^#{url}(\/|\/.+?|)$"
  )
  Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
    page.parts.create(:title => default_page_part, :body => nil, :position => index)
  end
end

# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed

# Added by Refinery CMS News engine
#Refinery::News::Engine.load_seed

# Added by Refinery CMS Venues extension
Refinery::Calendar::Engine.load_seed

# Added by Refinery CMS Marketing extension
Refinery::Marketing::Engine.load_seed

# Added by Refinery CMS Business extension
Refinery::Business::Engine.load_seed

# Added by Refinery CMS Parcels extension
Refinery::Parcels::Engine.load_seed

# Added by Refinery CMS Employees extension
Refinery::Employees::Engine.load_seed

# Added by Refinery CMS Store extension
Refinery::Store::Engine.load_seed

# Added by Refinery CMS CustomLists extension
Refinery::CustomLists::Engine.load_seed

# Added by Refinery CMS PageRoles extension
Refinery::PageRoles::Engine.load_seed

# Added by Refinery CMS QualityAssurance extension
Refinery::QualityAssurance::Engine.load_seed

# Added by Refinery CMS ResourceAuthorizations extension
Refinery::ResourceAuthorizations::Engine.load_seed
