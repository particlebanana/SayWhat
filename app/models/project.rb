class Project < ActiveRecord::Base
  
  belongs_to :group
  has_many :comments
  
  mount_uploader :profile, ProfileUploader
  
  attr_protected :name, :group, :comments

  validates_presence_of [:name, :display_name, :location, :start_date, :end_date, :focus, :goal, :description, :audience, :involves]
  validates_uniqueness_of [:name]
  
  before_validation :escape_name
  after_validation :sanitize

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
