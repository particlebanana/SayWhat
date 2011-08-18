class Comments < ActiveRecord::Migration
  def up
    create_table(:comments) do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :comment
            
      t.timestamps
    end
    
    add_index :comments, :user_id
    add_index :comments, :project_id
  end

  def down
    drop_table :comments
  end
end
