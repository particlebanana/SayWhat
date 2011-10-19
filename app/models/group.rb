class Group < ActiveRecord::Base
  
  mount_uploader :profile_photo, ProfileUploader

  has_many :users
  has_many :projects
  has_many :group_comments
  has_many :memberships
  
  attr_accessible :display_name, :city, :organization, :description, :permalink, :esc_region, :dshs_region, :area, :profile_photo

  validates_presence_of [:display_name, :city, :organization, :permalink, :status, :esc_region, :dshs_region, :area]
  validates_uniqueness_of [:name, :permalink]
  validates_length_of :permalink, within: 4..20
  
  before_validation :downcase_name
  after_validation :sanitize

  after_create :create_object_key
  after_update :recreate_object_key

  # Override ID params to use :permalink
  def to_param
    permalink
  end
  
  # Scopes
  def self.pending
    where(status: "pending")
  end
  
  def self.active
    where(status: "active")
  end
  
  def active?
    self.status == 'active' ? true : false
  end

  # Get the Group's Adult Sponsor
  def adult_sponsor
    self.users.where(role: "adult sponsor").first
  end
  
  # Initialize a new pending group and send notifications
  def initialize_pending(requestor)
    return false unless setup_group
    return false unless requestor.join_group(self.id)
    requestor.change_role_level("adult sponsor")
    send_notifications(requestor)
    true
  end
  
  def approve(url)
    self.status = "active"
    if self.save
      create_approved_group_timeline_event
      GroupMailer.send_approved_notice(self.adult_sponsor, self, url).deliver
      true
    else
      false
    end
  end

  # Completely remove a group and sponsor account
  def deny(reason)
    user = self.adult_sponsor
    if self.destroy && user.destroy && reason.is_a?(Hash)
      GroupMailer.send_denied_notice(user, self, reason['email_text']).deliver
      true
    else
      false
    end
  end

  # Reassign a group sponsor to another group member
  def reassign_sponsor(user_id)
    current_sponsor = adult_sponsor
    proposed_sponsor = self.users.find(user_id)
    if current_sponsor && proposed_sponsor
      current_sponsor.change_role_level("member")
      proposed_sponsor.change_role_level("adult sponsor")
    end
  end  

  protected
  
  def downcase_name
    self.name = self.display_name.downcase if self.display_name
  end
    
  def sanitize
    self.description = Sanitize.clean(self.description, Sanitize::Config::RESTRICTED) if self.description
  end
  
  private
  
  # Create a permalink slug and set status
  def setup_group
    self.status = 'pending'
    make_slug
    self.valid? && self.save! ? true : false
  end
  
  # Send group notifications
  def send_notifications(user)
    GroupMailer.successful_group_request(user, self).deliver
    admins = User.site_admins
    admins.each {|e| GroupMailer.admin_pending_group_request(e, self, user).deliver }
  end
  
  # Make a permalink slug
  def make_slug
    self.permalink = (self.permalink.downcase.gsub(/[^a-zA-Z 0-9]/, "")).gsub(/\s/,'-') if self.permalink
  end

  # Create an object in the Activity Feed
  def create_object_key
    $feed.record("group:#{id}", { id: self.permalink, name: self.display_name } )
  end

  # On model update, destroy the current object and recreate it
  def recreate_object_key
    $feed.unrecord("group:#{id}")
    data = { id: self.permalink, name: self.display_name }
    data[:photo] = self.profile_photo_url(:thumb) if self.profile_photo
    $feed.record("group:#{id}", data)
  end

  # Add an event to global timeline when a group is approved
  def create_approved_group_timeline_event
    sponsor = self.adult_sponsor
    event = Chronologic::Event.new(
      key: "group:#{self.id}:create",
      data: { type: "message", message: "#{sponsor.name} created the group #{self.display_name}" },
      timelines: ["global_feed", "group:#{self.id}", "user:#{sponsor.id}"],
      objects: { user: "user:#{sponsor.id}", group: "group:#{self.id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end
end