class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.text :config # a serialized hash of config info for user and his/her blog

      t.timestamps
    end
    
    add_index :users, :email
    
    add_column :posts, :user_id, :integer
  end
  
  def down
    remove_column :posts, :user_id
    drop_table :users
  end
end
