class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :user, autosave: true
  
  field :message_type # Message Type can be: "request", "message"
  field :message_author
  field :message_subject
  field :message_content
  field :message_payload
  field :read, :type => Boolean, :default => false
  
  default_scope desc(:created_at)
  
  attr_accessible :message_subject, :message_content
  
  validates_presence_of [:message_type, :message_author, :message_subject, :message_content]
  
  scope :unread, :where => {:read => false}
  
end
