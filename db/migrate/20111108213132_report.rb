class Report < ActiveRecord::Migration
  def up
    create_table(:reports) do |t|
      t.references :group
      t.references :project
      t.integer :number_of_youth_reached
      t.integer :number_of_adults_reached
      t.float :percent_male
      t.float :percent_female
      t.float :percent_african_american
      t.float :percent_asian
      t.float :percent_caucasian
      t.float :percent_hispanic
      t.float :percent_other
      t.string :money_spent
      t.string :prep_time
      t.string :other_resources
      t.string :level_of_impact
      t.text :comment
      t.timestamps
    end
    
    add_index :reports, [:group_id, :project_id], :unique => true
  end

  def down
    drop_table :reports
  end
end
