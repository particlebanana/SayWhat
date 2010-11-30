class Project
  include Mongoid::Document
  field :name
  field :display_name
  field :location
  field :start_date, :type => Date
  field :end_date, :type => Date
  field :description
  embedded_in :group, :inverse_of => :projects
  
  attr_accessible :display_name, :location, :start_date, :end_date, :description

  validates_presence_of [:name, :display_name, :location, :start_date, :end_date, :description]
  validates_uniqueness_of [:name]
  
  before_validation :downcase_name

  protected
  
    def downcase_name
      if self.display_name
        self.name = CGI.escape(self.display_name.downcase)
      end
    end

end
