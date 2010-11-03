class Group
  include Mongoid::Document
  field :name
  field :city
  field :organization
  field :description
  field :status

  attr_accessible :name, :city, :organization, :description

  validates_presence_of [:name, :city, :organization]
  
  validates_uniqueness_of [:name]

end

