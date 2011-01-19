class ProjectCache
  include Mongoid::Document
  include Mongoid::Timestamps
  field :group_id
  field :group_name
  field :group_permalink
  field :project_id
  field :project_name
  field :project_permalink
  field :focus
  field :audience
  field :profile_photo
  field :start_date, :type => Date
  field :end_date, :type => Date
  field :reported, :type => Boolean, :default => false
    
  validates_presence_of [:group_id, :project_id, :group_name, :group_permalink, :project_name, :project_permalink, :focus, :audience, :start_date, :end_date]
  validates_uniqueness_of [:project_id]
  
    
  def self.filter(focus, audience)
    projects = Mongoid::Criteria.new(self)
    projects = projects.where(:focus => focus) unless focus == 'Filter by Focus'
    projects = projects.where(:audience => audience) unless audience == 'Filter by Audience'
    projects
  end
  
end
