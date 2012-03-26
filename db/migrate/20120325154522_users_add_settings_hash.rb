class UsersAddSettingsHash < ActiveRecord::Migration
  def up
    add_column :users, :settings, :text
  end

  def down
    remove_column :users, :settings
  end
end
