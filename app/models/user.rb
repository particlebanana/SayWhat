require 'carrierwave/orm/mongoid'
class User
  include Mongoid::Document      
  devise :database_authenticatable, :token_authenticatable, :recoverable, :rememberable, :validatable
  field :first_name
  field :last_name
  field :role
  field :status
  field :bio
  field :authentication_token
  referenced_in :group
  references_many :comments
  embeds_many :messages
  mount_uploader :avatar, AvatarUploader


  attr_accessible :email, :first_name, :last_name, :bio, :password, :password_confirmation, :avatar, :remember_me

  validates_presence_of [:first_name, :last_name, :email, :role, :status]
  
  before_validation :downcase_attributes
  
  before_validation :generate_temp_password
  before_create :reset_authentication_token
    
  scope :site_admins, :where => {:role => "admin"}
  
  scope :setup, :where => {:status => "setup"}
  scope :active, :where => {:status => "active"}
  scope :pending, :where => {:status => "pending"}
  
  scope :adult_sponsor, :where => {:role => "adult sponsor" }
  scope :youth_sponsor, :where => {:role => "youth sponsor" }
  scope :members, :where => {:role => "member"}
  
  
  protected
  
    def downcase_attributes
      self.email ? self.email.downcase! : nil
    end
      
    def generate_temp_password
      if self.encrypted_password == ""
        temp_pass = generate_random_key
        self.password ||= temp_pass
        self.password_confirmation ||= temp_pass
      end
    end    
    
  public
  
    # Create a message object
    def create_message_object(message_object)
      message = Message.new
      message.message_type = message_object[:message_type]
      message.message_author = message_object[:message_author]
      message.message_subject = message_object[:message_subject]
      message.message_content = message_object[:message_content]
      self.messages << message
      message.save!
    end
    
    # Create a message request object
    def create_message_request_object(request_name, request_email, request_id)
      message = Message.new(:message_subject => "New Membership Request")
      message.message_author = "Automated Message"
      message.message_type = "request"
      message.message_content = "
      You have a pending membership request. Please review the information below and choose to either accept or deny the member.<br/>
      Name: #{request_name}
      Email: #{request_email}"
      message.message_payload = request_id
      self.messages << message
      message.save!
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

  private
  
    def generate_random_key
      chars = ("a".."z").to_a + ("1".."9").to_a 
      key = Array.new(15, '').collect{chars[rand(chars.size)]}.join
    end
    
end