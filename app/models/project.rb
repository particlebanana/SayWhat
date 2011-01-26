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
  embeds_one :report
  mount_uploader :profile_photo, ProfileUploader
  
  attr_protected :name, :group, :comments

  validates_presence_of [:name, :display_name, :location, :start_date, :end_date, :focus, :goal, :description, :audience, :involves]
  validates_uniqueness_of [:name]
  
  before_validation :escape_name
  after_validation :sanitize
  
  after_save :cache_project
  
  before_destroy :set_cache
  after_destroy :destroy_cache

  protected
  
    def escape_name
      if self.display_name
        self.name = (self.display_name.downcase.gsub(/[^a-zA-Z 0-9]/, "")).gsub(/\s/,'-')
      end
    end
    
    def sanitize
      self.goal = Sanitize.clean(self.goal, Sanitize::Config::RESTRICTED) if self.goal
      self.description = Sanitize.clean(self.description, Sanitize::Config::RESTRICTED) if self.description
      self.involves = Sanitize.clean(self.involves, Sanitize::Config::RESTRICTED) if self.involves
    end
    
  private
  
    def cache_project
      cache = ProjectCache.find_or_create_by(:group_id => self.group.id.to_s, :project_id => self.id.to_s)
      cache.update_attributes(
        :group_name => self.group.display_name, 
        :group_permalink => self.group.permalink, 
        :project_name => self.display_name, 
        :project_permalink => self.name, 
        :focus => self.focus, 
        :audience => self.audience,
        :profile_photo => self.profile_photo_url(:small),
        :start_date => self.start_date,
        :end_date => self.end_date
      )
      cache.save
    end
    
    def set_cache
      @cache = ProjectCache.find(:first, :conditions => {:group_id => self.group.id.to_s, :project_id => self.id.to_s})
    end
    
    def destroy_cache
      @cache.destroy if @cache
    end
        
  public
  
    def filters
      focus = ['Filter by Focus', 'Secondhand Smoke Exposure', 'General Education', 'Health Effects', 'Policy Focused', 'Industry Manipulation', 'Access/Enforcement', 'Marketing/Advertising']
      audience = ['Filter by Audience', 'Elementary Students', 'Middle School Students', 'High School Students', 'Community Members', 'Government Officials']
      filters = {
        :focus => focus.map { |focus| [focus, focus] },
        :audience => audience.map { |audience| [audience, audience] }
      }
    end
        
end
