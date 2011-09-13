class Message < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessible :subject, :content
  
  validates_presence_of [:message_type, :author, :subject, :content]
  
  # Scopes
  def self.unread; where(read: false) end
  
  def self.create_group_request(group, user, sponsor)
    options = { name: user.name, email: user.email, payload: { group: group.id, user: user.id } }
    message = self.group_request_object(options)
    message.user = sponsor
    if message.save
      UserMailer.successful_membership_request(user, group).deliver
      UserMailer.sponsor_pending_membership_request(sponsor, group, user).deliver
      message
    else
      false
    end
  end
  
  # Send Message to all admins
  def self.alert_admins(options)
    admins = User.site_admins
    admins.each do |admin|
      GroupMailer.admin_pending_group_request(admin, options[:group], options[:user]).deliver
    end
  end
  
  private
  
  def self.group_request_object(options)
    message = self.new(subject: "New Membership Request")
    message.author = "Automated Message"
    message.message_type = "request"
    message.content = "Someone would like to join your group! You may choose to accept them or if you don't know them you can deny their request.
                       Name: #{options[:name]}
                       Email: #{options[:email]}"
    message.payload = options[:payload]
    return message
  end
  
end
