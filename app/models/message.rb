class Message < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :subject, :content
  
  validates_presence_of [:message_type, :author, :subject, :content]
  
  # Scopes
  def self.unread; where(read: false) end
  
  # Send Message to all admins
  def self.alert_admins(options)
    admins = User.site_admins
    admins.each do |admin|
      GroupMailer.admin_pending_group_request(admin, options[:group], options[:user]).deliver
    end
  end
  
end
