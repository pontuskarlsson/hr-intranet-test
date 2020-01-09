# This migration comes from refinery_blog (originally 20160602042848)
class AddUsernameToBlogPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :refinery_blog_posts, :username, :string
  end
end