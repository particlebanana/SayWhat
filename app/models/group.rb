class Group
  include Mongoid::Document
  field :name
  field :city
  field :organization
  field :description
  field :status
  references_many :users, :dependent => :delete
  
  attr_accessible :name, :city, :organization, :description

  validates_presence_of [:name, :city, :organization, :status]
  validates_uniqueness_of [:name]
  
  before_validation [:downcase_attributes]
  
  protected
  
    def downcase_attributes
      self.name.downcase!
    end

end

