class Projects < ActiveRecord::Migration
  def up
    create_table(:projects) do |t|
      t.references :group
      t.string :name
      t.string :display_name
      t.string :location
      t.date :start_date
      t.date :end_date
      t.string :focus
      t.string :goal
      t.text :description
      t.string :audience
      t.string :involves
      
      t.timestamps
    end
    
    add_index :projects, :name,        :unique => true
    add_index :projects, :group_id
  end

  def down
    drop_table :projects
  end
end
