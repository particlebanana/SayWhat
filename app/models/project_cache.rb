class ProjectCache
  include Mongoid::Document
  field :group_id
  field :group_name
  field :group_permalink
  field :project_id
  field :project_name
  field :project_permalink
  field :focus
  field :audience
    
  validates_presence_of [:group_id, :project_id, :group_name, :group_permalink, :project_name, :project_permalink, :focus, :audience]
  validates_uniqueness_of [:project_id]
  
end
