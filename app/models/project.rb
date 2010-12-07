class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :display_name
  field :location
  field :start_date, :type => Date
  field :end_date, :type => Date
  field :focus
  field :goal
  field :description
  field :audience
  field :involves
  embedded_in :group, :inverse_of => :projects
  embeds_many :comments
  
  attr_protected :name, :group, :comments

  validates_presence_of [:name, :display_name, :location, :start_date, :end_date, :focus, :goal, :description, :audience, :involves]
  validates_uniqueness_of [:name]
  
  before_validation :downcase_name
  
  after_save :cache_project

  protected
  
    def downcase_name
      if self.display_name
        self.name = CGI.escape(self.display_name.downcase)
      end
    end
    
  private
  
    def cache_project
      cache = ProjectCache.find_or_create_by(:group_id => self.group.id.to_s, :project_id => self.id.to_s)
      cache.update_attributes(
        :group_name => self.group.display_name, 
        :group_permalink => self.group.name, 
        :project_name => self.display_name, 
        :project_permalink => self.name, 
        :focus => self.focus, 
        :audience => self.audience
      )
      cache.save
    end
        
  public
  
    def filters
      focus = ['', 'Secondhand Smoke Exposure', 'General Education', 'Health Effects', 'Policy Focused', 'Industry Manipulation', 'Access/Enforcement', 'Marketing/Advertising']
      audience = ['', 'Elementary Students', 'Middle School Students', 'High School Students', 'Community Members', 'Government Officials']
      filters = {
        :focus => focus.map { |focus| [focus, focus] },
        :audience => audience.map { |audience| [audience, audience] }
      }
    end

end
