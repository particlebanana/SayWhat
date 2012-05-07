class Project < ActiveRecord::Base
  
  belongs_to :group
  has_many :photos, :foreign_key => 'project_id', :class_name => "ProjectPhoto"
  has_one :grant
  has_one :report
  
  mount_uploader :profile_photo, ProfileUploader
  
  attr_protected :name, :group, :comments

  validates_presence_of [:name, :display_name, :location, :start_date, :focus, :audience, :description]
  validates_uniqueness_of :name

  validates :focus, :inclusion => { :in => [
    'Secondhand Smoke Exposure', 'General Education', 'Health Effects',
    'Policy Focused', 'Industry Manipulation', 'Access/Enforcement', 'Marketing/Advertising']}

  validates :audience, :inclusion => { :in => [
    'Elementary Students', 'Middle School Students', 'High School Students',
    'Community Members', 'Government Officials']}
  
  before_validation :escape_name
  after_validation :sanitize
  
  # Manage Activity Timeline
  after_create :async_publish_project
  after_update :async_recreate_object_key

  def self.filters
    focus = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects', 'Policy Focused', 'Industry Manipulation', 'Access/Enforcement', 'Marketing/Advertising']
    audience = ['Elementary Students', 'Middle School Students', 'High School Students', 'Community Members', 'Government Officials']
    filters = {
      focus: focus.map { |focus| [focus, focus] },
      audience: audience.map { |audience| [audience, audience] }
    }
  end

  def format_dates(start, stop=nil)
    self.start_date = Date.strptime(start, "%m/%d/%Y") unless start.is_a? Date
    if stop.blank?
      self.end_date = ''
    else
      self.end_date = Date.strptime(stop, "%m/%d/%Y") unless stop.is_a? Date
    end
  end

  protected

  def escape_name
    self.name = (self.display_name.downcase.gsub(/[^a-zA-Z 0-9]/, "")).gsub(/\s/,'-') if self.display_name
  end

  def sanitize
    self.goal = Sanitize.clean(self.goal, Sanitize::Config::RESTRICTED) if self.goal
    self.description = Sanitize.clean(self.description, Sanitize::Config::RESTRICTED) if self.description
    self.involves = Sanitize.clean(self.involves, Sanitize::Config::RESTRICTED) if self.involves
  end

  def async_publish_project
    Resque.enqueue(NewProjectJob, self.id)
  end

  def async_recreate_object_key
    Resque.enqueue(UpdateProjectJob, self.id)
  end
end