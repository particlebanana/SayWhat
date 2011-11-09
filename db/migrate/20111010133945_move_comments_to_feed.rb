class MoveCommentsToFeed < ActiveRecord::Migration
  def up
    drop_table :group_comments
    drop_table :project_comments
  end

  def down
    create_table :group_comments do |t|
      t.integer :user_id
      t.integer :group_id
      t.text :comment
      t.timestamps
    end
    
    add_index :group_comments, :user_id
    add_index :group_comments, :group_id
    
    create_table :project_comments do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :comment
      t.timestamps
    end
    
    add_index :project_comments, :user_id
    add_index :project_comments, :project_id
  end
end
