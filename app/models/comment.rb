class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :project

  field :comment
  
  attr_accessible :comment

  validates_presence_of [:comment, :user_id]
  
  after_validation :sanitize
  
  protected
  
    def sanitize
      self.comment = Sanitize.clean(self.comment, Sanitize::Config::RESTRICTED) if self.comment
    end
  
end
