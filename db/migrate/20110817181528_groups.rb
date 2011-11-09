class Groups < ActiveRecord::Migration
  def up
    create_table(:groups) do |t|
      t.string :name
      t.string :display_name
      t.string :city
      t.string :organization
      t.text :description
      t.string :permalink
      t.string :status
      t.string :esc_region, default: 'pending'
      t.string :dshs_region, default: 'pending'
      t.string :area, default: 'pending'
      t.timestamps
    end
    
    add_index :groups, :name,        :unique => true
    add_index :groups, :permalink,   :unique => true
  end

  def down
    drop_table :groups
  end
end