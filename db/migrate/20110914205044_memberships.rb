class Memberships < ActiveRecord::Migration
  def up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end

    add_index :memberships, [:user_id, :group_id]
  end

  def down
    drop_table :memberships
  end
end
