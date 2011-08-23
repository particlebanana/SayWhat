class ImageUploads < ActiveRecord::Migration
  def up
    add_column :users, :avatar, :string
    add_column :projects, :profile, :string
    add_column :groups, :profile, :string
  end

  def down
    remove_column :users, :avatar
    remove_column :projects, :profile 
    remove_column :groups, :profile
  end
end
