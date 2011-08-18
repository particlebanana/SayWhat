class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  attr_accessible :comment
  validates_presence_of [:comment, :user_id, :project_id]

  after_validation :sanitize
  
  protected
  
    def sanitize
      self.comment = Sanitize.clean(self.comment, Sanitize::Config::RESTRICTED) if self.comment
    end
  
end
