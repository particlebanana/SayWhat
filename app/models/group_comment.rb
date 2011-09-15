class GroupComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  attr_accessible :comment
  validates_presence_of [:comment, :user_id, :group_id]

  after_validation :sanitize
  
  protected
  
  def sanitize
    self.comment = Sanitize.clean(self.comment, Sanitize::Config::RESTRICTED) if self.comment
  end
  
end
