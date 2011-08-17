class LinkGroupsUsers < ActiveRecord::Migration
  def up
    add_column :users, :group_id, :integer
    add_index(:users, :group_id, :name => 'index_users_on_group_id', :unique => true)
  end

  def down
    remove_column :users, :group_id
    remove_index(:users, :name => 'index_users_on_group_id')
  end
end
