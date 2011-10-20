class ProjectPhoto < ActiveRecord::Base

  belongs_to :project

  validates_presence_of [:photo]
end
