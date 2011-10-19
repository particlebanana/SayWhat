class UserPhoto < ActiveRecord::Migration
  def up
    remove_column :users, :avatar
    add_column :users, :profile_photo, :string
  end

  def down
    remove_column :users, :profile_photo
    add_column :users, :avatar, :string
  end
end
