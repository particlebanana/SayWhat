class User
  include Mongoid::Document 
  ROLES = %w[admin]        
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  field :username
  field :first_name
  field :last_name
  field :role
  referenced_in :group

  attr_accessible :email, :username, :first_name, :last_name, :password, :password_confirmation, :remember_me

  validates_presence_of [:first_name, :last_name, :email, :username, :role]
  validates_uniqueness_of [:username]
  
  before_validation :downcase_attributes
  before_validation :generate_temp_password
  
  protected
  
    def downcase_attributes
      username.downcase!
      email.downcase!
    end
  
    def generate_temp_password
      chars = ("a".."z").to_a + ("1".."9").to_a 
      tempPass = Array.new(8, '').collect{chars[rand(chars.size)]}.join
      self.password ||= tempPass
      self.password_confirmation ||= tempPass
    end

end