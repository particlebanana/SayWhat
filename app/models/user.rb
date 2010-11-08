class User
  include Mongoid::Document      
  devise :token_authenticatable, :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable
  field :username
  field :first_name
  field :last_name
  field :role
  field :status
  field :authentication_token
  referenced_in :group

  attr_accessible :email, :username, :first_name, :last_name, :password, :password_confirmation, :remember_me

  validates_presence_of [:first_name, :last_name, :email, :username, :role, :status]
  validates_uniqueness_of [:username]
  
  before_validation :downcase_attributes
  before_validation :generate_temp_password
  before_validation :manage_token
  
  scope :adult_sponsor, :where => {:role => "adult sponsor" }
  scope :setup, :where => {:status => "setup"}
  
    
  protected
  
    def downcase_attributes
      username.downcase!
      email.downcase!
    end
  
    def generate_temp_password
      temp_pass = generate_random_key
      self.password ||= temp_pass
      self.password_confirmation ||= temp_pass
    end
    
    def manage_token
      self.status == "setup" ? generate_token : destroy_token
    end
    
    def generate_token
      key = generate_random_key
      self.authentication_token ||= key
    end
    
    def destroy_token
      self.authentication_token = nil
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
  
  #  def active?
  #    super && account_active?
  #  end
    
  #  def account_active?
  #    role != "pending"
  #  end
    
end