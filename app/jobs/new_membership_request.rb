# Send a notification to a Group Sponsor
# when a user requests group membership
class NewMembershipRequest
  @queue = :notifications

  # Public: Send a notification to a Group Sponsor
  # when a user requests group membership.
  #
  # This job manages notifiying a group sponsor when a 
  # new group membership request comes in. It will publish
  # a notification to their account and send them an email
  # to alert an action needs to be taken.
  #
  # membership_id - The membership id of the member request
  # sponsor_id - The user_id of the group's sponsor
  # message_text - The text to include in the notification
  # message_link - The link to approve the member on their profile
  # user_id - The user id of the member requesting access
  #
  # Returns nothing. It's a worker task
  def self.perform(membership_id, sponsor_id, message_text, message_link, user_id)
    membership = Membership.find(membership_id)
    notification = Notification.new(sponsor_id)
    sponsor = User.find(sponsor_id)
    user = User.find(user_id)

    message = {
      text: message_text,
      link: message_link
    }

    obj = self.new(membership, notification, message, sponsor, user)
    obj.create_notification
    obj.send_sponsor_email
  end

  def initialize(membership, notification, message, sponsor, user)
    @membership = membership
    @notification = notification
    @message = message
    @sponsor = sponsor
    @user = user
  end

  def create_notification
    @notification.insert(@message)
    @membership.notification = @notification.notifications[0].id.to_s
    @membership.save
  end

  def send_sponsor_email
    UserMailer.sponsor_pending_membership_request(@sponsor, @sponsor.group, @user).deliver
  end
end

