class Project
  include Mongoid::Document
  field :name
  field :location
  field :start_date, :type => Date
  field :end_date, :type => Date
  field :description
  references_one :group
  
  attr_accessible :name, :location, :start_date, :end_date, :description

  validates_presence_of [:name, :location, :start_date, :end_date, :description]

end
