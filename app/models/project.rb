class Project < ActiveRecord::Base
  
  belongs_to :group
  has_many :project_comments
  
  mount_uploader :profile_photo, ProfileUploader
  
  attr_protected :name, :group, :comments

  validates_presence_of [:name, :display_name, :location, :start_date, :end_date, :focus, :audience, :description]
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
  after_create :create_object_key
  after_create :write_initial_event

  def self.filters
    focus = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects', 'Policy Focused', 'Industry Manipulation', 'Access/Enforcement', 'Marketing/Advertising']
    audience = ['Elementary Students', 'Middle School Students', 'High School Students', 'Community Members', 'Government Officials']
    filters = {
      focus: focus.map { |focus| [focus, focus] },
      audience: audience.map { |audience| [audience, audience] }
    }
  end
  
  # Publish to Project and Group feed
  def publish_to_feed(msg)
    event = Chronologic::Event.new(
      key: "project:#{self.id}:create",
      data: { type: "message", message: "#{msg}"},
      timelines: ["group:#{self.group.id}", "project:#{self.id}"],
      objects: { group: "group:#{self.group.id}", project: "project:#{self.id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
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

  # Create an object in the Activity Feed
  def create_object_key
    $feed.record("project:#{id}", { id: self.id, name: self.display_name } )
  end

  # Add an event to project timeline when a new project is created
  def write_initial_event
    publish_to_feed("#{self.group.display_name} created a new project: #{self.display_name}")
  end
end
