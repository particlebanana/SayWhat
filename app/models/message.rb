class Message < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :subject, :content
  
  validates_presence_of [:message_type, :author, :subject, :content]
  
  #default_scope desc(:created_at)
  
  def self.unread
    where(read: false)
  end
  
end
