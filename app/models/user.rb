class User
  include Mongoid::Document      
  devise :database_authenticatable, :token_authenticatable, :recoverable, :rememberable, :validatable, :registerable
  field :username
  field :first_name
  field :last_name
  field :role
  field :status
  field :authentication_token
  referenced_in :group

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :remember_me

  validates_presence_of [:first_name, :last_name, :email, :username, :role, :status]
  validates_uniqueness_of [:username]
  
  before_validation :generate_temp_username
  before_validation :downcase_attributes
  
  before_validation :generate_temp_password
  before_create :reset_authentication_token
    
  scope :adult_sponsor, :where => {:role => "adult sponsor" }
  scope :setup, :where => {:status => "setup"}
  
    
  protected
  
    def downcase_attributes
      username.downcase!
      email.downcase!
    end
    
    def generate_temp_username
      self.username ||= generate_random_key
    end
  
    def generate_temp_password
      if self.encrypted_password == ""
        temp_pass = generate_random_key
        self.password ||= temp_pass
        self.password_confirmation ||= temp_pass
      end
    end    
    
  public
    
    # Role Checks  
    def admin?
      role == "admin" ? true : false
    end    
    
    def setup?
      role == "adult sponsor" && status == "setup" ? true : false
    end

  private
  
    def generate_random_key
      chars = ("a".."z").to_a + ("1".."9").to_a 
      key = Array.new(15, '').collect{chars[rand(chars.size)]}.join
    end
    
end