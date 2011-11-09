class Messages < ActiveRecord::Migration
  def up
    create_table(:messages) do |t|
      t.integer :user_id
      t.string :message_type # Message Type can be: "request", "message"
      t.string :author
      t.string :subject
      t.text :content
      t.string :payload
      t.boolean :read, default: false
            
      t.timestamps
    end
    
    add_index :messages, :user_id
  end

  def down
    drop_table :messages
  end
end
