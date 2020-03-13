# This migration comes from refinery_addons (originally 1)
class CreateAddonsComments < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_addons_comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :comment_by_id
      t.string :comment_by_type
      t.string :comment_by_email
      t.string :comment_by_full_name
      t.integer :zendesk_id
      t.text :zendesk_meta

      t.text :body
      t.datetime :commented_at

      t.timestamps
    end

    add_index :refinery_addons_comments, [:commentable_id, :commentable_type], name: 'INDEX_ra_comments_ON_commentable_id_and_commentable_type'
    add_index :refinery_addons_comments, [:comment_by_id, :comment_by_type], name: 'INDEX_ra_comments_ON_comment_by_id_and_comment_by_type'
    add_index :refinery_addons_comments, :zendesk_id
    add_index :refinery_addons_comments, :commented_at
  end

end
