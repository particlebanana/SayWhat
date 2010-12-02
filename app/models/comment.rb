class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  referenced_in :user, :inverse_of => :comments, :index => true
  embedded_in :project, :inverse_of => :comments, :index => true
  field :comment
  
  attr_accessible :comment

  validates_presence_of [:comment, :user_id]
  
end
