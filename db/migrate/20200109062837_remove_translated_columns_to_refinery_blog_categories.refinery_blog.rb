# This migration comes from refinery_blog (originally 20180420132008)
class RemoveTranslatedColumnsToRefineryBlogCategories < ActiveRecord::Migration[5.1]
  def change
    remove_column :refinery_blog_categories, :title
  end
end
