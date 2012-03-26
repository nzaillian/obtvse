class UsersTableRemoveSettingsColumn < ActiveRecord::Migration
  def up
    remove_column :users, :settings
  end

  def down
    add_column :users, :settings, :text
  end
end
