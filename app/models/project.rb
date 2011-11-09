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
  after_create :create_object_key
  after_create :write_initial_event
  after_update :recreate_object_key

  def self.filters
    focus = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects', 'Policy Focused', 'Industry Manipulation', 'Access/Enforcement', 'Marketing/Advertising']
    audience = ['Elementary Students', 'Middle School Students', 'High School Students', 'Community Members', 'Government Officials']
    filters = {
      focus: focus.map { |focus| [focus, focus] },
      audience: audience.map { |audience| [audience, audience] }
    }
  end

  def format_dates(start, stop=nil)
    self.start_date = Date.strptime(start, "%m/%d/%Y")
    self.end_date = Date.strptime(stop, "%m/%d/%Y") unless stop.blank?
  end
  
  # Publish to Project and Group feed
  def publish_to_feed(key, msg)
    event = Chronologic::Event.new(
      key: key,
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

  # On model update, destroy the current object and recreate it
  def recreate_object_key
    $feed.unrecord("project:#{id}")
    data = { id: self.id, name: self.display_name }
    data[:photo] = self.profile_photo_url(:thumb) if self.profile_photo
    $feed.record("project:#{id}", data)
  end

  # Add an event to project timeline when a new project is created
  def write_initial_event
    publish_to_feed("project:#{self.id}:create", "#{self.group.display_name} created a new project: #{self.display_name}")
  end
end
