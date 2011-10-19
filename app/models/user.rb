class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  belongs_to :group
  has_many :group_comments
  has_many :project_comments
  has_many :memberships
  
  mount_uploader :profile_photo, ProfileUploader
  
  attr_accessible :email, :first_name, :last_name, :bio, :password, :password_confirmation, :remember_me, :profile_photo

  before_validation :set_defaults

  validates_presence_of [:first_name, :last_name, :email, :role, :status]
  validates_uniqueness_of :email
  validates_format_of :email, with: Devise::email_regexp
  
  before_create :reset_authentication_token
  after_create :create_object_key
  after_create :subscribe_to_global

  # Scopes  
  def self.site_admins; where(role: "admin") end
  def self.active; where(status: "active") end
  def self.pending; where(status: "pending") end
  def self.adult_sponsor; where(role: "adult sponsor") end
  def self.youth_sponsor; where(role: "youth sponsor") end
  def self.members; where(role: "member") end

  # Combine First Name and Last Name
  def name
    first_name + ' ' + last_name 
  end
  
  # Change User Role
  def change_role_level(level)
    self.role = level
    self.save! ? true : false
  end
  
  # Activate User
  def activate
    self.status = "active"
    self.role = "member"
    self.save! ? true : false
  end
  
  # Join a group
  def join_group(group_id)
    self.group_id = group_id
    if status = self.save! ? true : false
      subscribe_to_group(group_id)
    end
    status
  end
  
  # Role Checks  
  def admin?
    self.role == "admin" ? true : false
  end    
  
  def adult_sponsor?
    self.role == "adult sponsor" ? true : false
  end
  
  def youth_sponsor?
    self.role == "youth sponsor" ? true : false
  end
  
  def sponsor?
    self.role == "adult sponsor" || self.role == "youth sponsor" ? true : false
  end

  # On model update, destroy the current object and recreate it
  def recreate_object_key
    $feed.unrecord("user:#{id}")
    data = { id: self.id, name: self.name }
    data[:photo] = self.profile_photo_url(:thumb) if self.profile_photo
    $feed.record("user:#{id}", data)
  end

  private

  # Set default role and status
  def set_defaults
    self.status ||= "active"
    self.role ||= "member"
  end

  # Create an object in the Activity Feed
  def create_object_key
    $feed.record("user:#{id}", { id: self.id,  name: self.name } )
  end

  # Subscribe to the Global Activity Feed
  def subscribe_to_global
    $feed.subscribe("user:#{id}", "global_feed")
  end

  # Subscribe to a group's feed
  def subscribe_to_group(group_id)
    $feed.subscribe("user:#{id}", "group:#{group_id}")
  end
end