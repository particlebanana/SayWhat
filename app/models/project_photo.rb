class ProjectPhoto < ActiveRecord::Base
  belongs_to :project
  mount_uploader :photo, PhotoUploader

  validates_presence_of [:photo]
end
