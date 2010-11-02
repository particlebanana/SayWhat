class User
  include Mongoid::Document         
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  field :username
  field :name

  attr_accessible :email, :username, :name, :password, :password_confirmation, :remember_me

  validates_presence_of [:name, :email, :username]
  validates_uniqueness_of [:email, :username]

end
