class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  belongs_to :group
  has_many :comments
  has_many :messages
  
  mount_uploader :avatar, AvatarUploader
  
  attr_accessible :email, :first_name, :last_name, :bio, :password, :password_confirmation, :avatar, :remove_avatar, :remember_me

  validates_presence_of [:first_name, :last_name, :email, :role, :status]
  validates_uniqueness_of :email
  validates_format_of :email, with: Devise::email_regexp
  
  before_create :reset_authentication_token
    
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
=begin  
  # Create a message object
  def create_message_object(message_object)
    message = Message.new
    message.message_type = message_object[:message_type]
    message.author = message_object[:author]
    message.subject = message_object[:subject]
    message.content = message_object[:content]
    self.messages << message
    message.save!
    message
  end
        
  # Create a message request object
  def create_message_request_object(request_name, request_email, request_id)
    message = Message.new(:subject => "New Membership Request")
    message.author = "Automated Message"
    message.message_type = "request"
    message.content = "
    You have a pending membership request. Please review the information below and choose to either accept or deny the member.<br/>
    Name: #{request_name}
    Email: #{request_email}"
    message.payload = request_id
    self.messages << message
    message.save!
    message
  end
=end
end