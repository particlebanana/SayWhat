class GrantStatus < ActiveRecord::Migration
  def up
    add_column :grants, :status, :string, default: 'in progress'
    add_index :grants, :status
  end

  def down
    remove_index :grants, :status
    remove_column :grants, :status
  end
end
