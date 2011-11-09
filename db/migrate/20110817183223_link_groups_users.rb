class LinkGroupsUsers < ActiveRecord::Migration
  def up
    add_column :users, :group_id, :integer
    add_index(:users, :group_id, :name => 'index_users_on_group_id')
  end

  def down
    remove_index(:users, :name => 'index_users_on_group_id')
    remove_column :users, :group_id
  end
end
