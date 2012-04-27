class Group < ActiveRecord::Base
  
  mount_uploader :profile_photo, ProfileUploader

  has_many :users
  has_many :projects
  has_many :group_comments
  has_many :memberships
  has_many :reports
  
  attr_accessible :display_name, :city, :organization, :description, :permalink, :esc_region, :dshs_region, :area, :profile_photo

  validates_presence_of [:display_name, :city, :organization, :permalink, :status, :esc_region, :dshs_region, :area]
  validates_uniqueness_of [:name, :permalink]
  validates_length_of :permalink, within: 4..20
  
  before_validation :downcase_name
  after_validation :sanitize

  after_update :async_recreate_object_key

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
    async_create_group_request(self.id, requestor.id)
    true
  end
  
  def approve(url)
    self.status = "active"
    if self.save
      async_manage_group_request(url, 'approve')
      true
    else
      false
    end
  end

  # Completely remove a group and sponsor account
  def deny(reason)
    if self.destroy && reason.is_a?(Hash)
      async_manage_group_request(reason['email_text'], 'deny')
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

  # Make a permalink slug
  def make_slug
    self.permalink = (self.permalink.downcase.gsub(/[^a-zA-Z 0-9]/, "")).gsub(/\s/,'-') if self.permalink
  end

  # Join the user to the group and send email notification to admins
  def async_create_group_request(group_id, user_id)
    Resque.enqueue(NewGroupJob, group_id, user_id)
  end

  def async_manage_group_request(data, method)
    user = self.adult_sponsor
    Resque.enqueue(ManageGroupRequestJob, user.id, self.id, data, method)
  end

  # On model update, destroy the current object key and recreate it
  def async_recreate_object_key
    Resque.enqueue(UpdateGroupJob, self.id)
  end
end