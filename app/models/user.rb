class User
  include Mongoid::Document 
  ROLES = %w[admin]        
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  field :username
  field :name
  field :role

  attr_accessible :email, :username, :name, :password, :password_confirmation, :remember_me

  validates_presence_of [:name, :email, :username, :role]
  validates_uniqueness_of [:email, :username]

end
