class Group
  include Mongoid::Document
  field :name
  field :display_name
  field :city
  field :organization
  field :description
  field :permalink
  field :status
  references_many :users, :dependent => :delete
  
  attr_accessible :display_name, :city, :organization, :description

  validates_presence_of [:name, :display_name, :city, :organization, :status]
  validates_uniqueness_of [:name]
  
  validates_uniqueness_of [:permalink]
  validates_length_of :permalink, :minimum => 4, :maximum => 20, :allow_nil => true
  
  before_validation :downcase_name
  before_validation :escape_permalink
  
  protected
  
    def downcase_name
      if self.display_name
        self.name = self.display_name.downcase
      end
    end
        
    def escape_permalink
      if permalink
        self.permalink = CGI.escape(self.permalink.downcase)
      end
    end

end

