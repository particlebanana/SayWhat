class RemoveMessages < ActiveRecord::Migration
  def up
    drop_table :messages
  end

  def down
    create_table(:messages) do |t|
      t.integer :user_id
      t.string :message_type
      t.string :author
      t.string :subject
      t.text :content
      t.string :payload
      t.boolean :read, default: false
            
      t.timestamps
    end
    
    add_index :messages, :user_id
  end
end
