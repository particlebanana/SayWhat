class ProjectPhotos < ActiveRecord::Migration
  def up
    create_table(:project_photos) do |t|
      t.references :project
      t.string :photo
      t.timestamps
    end
  
    add_index :project_photos, :project_id
  end

  def down
    drop_table :project_photos
  end
end
