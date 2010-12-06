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
  
  attr_accessible :display_name, :location, :start_date, :end_date, :focus, :goal, :description, :audience, :involves

  validates_presence_of [:name, :display_name, :location, :start_date, :end_date, :focus, :goal, :description, :audience, :involves]
  validates_uniqueness_of [:name]
  
  before_validation :downcase_name

  protected
  
    def downcase_name
      if self.display_name
        self.name = CGI.escape(self.display_name.downcase)
      end
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
