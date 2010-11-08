class Group
  include Mongoid::Document
  field :name
  field :city
  field :organization
  field :description
  field :permalink
  field :status
  references_many :users, :dependent => :delete
  
  attr_accessible :name, :city, :organization, :description

  validates_presence_of [:name, :city, :organization, :status]
  validates_uniqueness_of [:name]
  
  validates_uniqueness_of [:permalink]
  validates_length_of :permalink, :minimum => 4, :maximum => 20, :allow_nil => true
  
  before_validation :downcase_name
  before_validation :escape_permalink
  
  protected
  
    def downcase_name
      self.name.downcase!
    end
    
    def escape_permalink
      if permalink
        self.permalink = CGI.escape(self.permalink.downcase)
      end
    end

end

