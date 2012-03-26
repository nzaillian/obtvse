class CreateBlogsTable < ActiveRecord::Migration
  def up
    create_table :blogs do |t|
      t.text :settings
      t.integer :user_id
      t.string :title
      t.string :tagline
      t.timestamps
    end
    add_index :blogs, :user_id
    
    # augment 'posts' table
    remove_column :posts, :user_id

    add_column :posts, :blog_id, :integer
    add_index :posts, :blog_id
  end

  def down
    drop_table :blogs
    remove_column :posts, :blog_id
    add_column :posts, :user_id, :integer
    add_index :posts, :user_id
  end
end
