class Users < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :status
      t.text :bio
      
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.token_authenticatable

      t.timestamps
    end
    
    add_index :users, :email,                :unique => true
    add_index :users, :authentication_token, :unique => true
  end

  def down
    drop_table :users
  end
end