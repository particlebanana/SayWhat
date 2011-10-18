class ProfilePhoto < ActiveRecord::Migration
  def up
    remove_column :groups, :profile
    remove_column :projects, :profile
    add_column :groups, :profile_photo, :string
    add_column :projects, :profile_photo, :string
  end

  def down
    remove_column :groups, :profile_photo
    remove_column :projects, :profile_photo
    add_column :groups, :profile, :string
    add_column :projects, :profile, :string
  end
end
