class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  belongs_to :group
  has_many :comments
  has_many :messages
  
  mount_uploader :avatar, AvatarUploader
  
  #default_scope asc(:created_at)

  attr_accessible :email, :first_name, :last_name, :bio, :password, :password_confirmation, :avatar, :remove_avatar, :remember_me

  validates_presence_of [:first_name, :last_name, :email, :role, :status]
  
  before_validation :downcase_attributes
  before_create :reset_authentication_token
    
  scope :site_admins, where(role: "admin")
  scope :setup, where(status: "setup")
  scope :active, where(status: "active")
  scope :pending, where(status: "pending")
  scope :adult_sponsor, where(role: "adult sponsor")
  scope :youth_sponsor, where(role: "youth sponsor")
  #scope :sponsors, where(role:.in: ["adult sponsor", "youth sponsor", "admin"])
  scope :members, where(role: "member")
  
  
  protected
  
    def downcase_attributes
      self.email ? self.email.downcase! : nil
    end  
    
  public
  
    # Demote/promote users to a certain access level
    def change_role_level(level)
      self.role = level
      self.save
    end
  
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
    
    # Role Checks  
    def admin?
      role == "admin" ? true : false
    end    
    
    def sponsor_setup?
      role == "adult sponsor" && status == "setup" ? true : false
    end
    
    def member_setup?
      role == "member" && status == "setup" ? true : false
    end
    
    def adult_sponsor?
      role == "adult sponsor" ? true : false
    end
    
    def youth_sponsor?
      role == "youth sponsor" ? true : false
    end
    
    def sponsor?
      role == "adult sponsor" || role == "youth sponsor" ? true : false
    end
    
    def name
      first_name + ' ' + last_name
    end
    
end