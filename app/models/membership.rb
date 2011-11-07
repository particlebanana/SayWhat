class Membership < ActiveRecord::Base
  
  # Handles Group Membership Request
  #
  # This is a perfect use case for adding Redis into the stack
  # however at this time that is impossible on my end due to
  # server restrictions. Will look into for future updates.
  belongs_to :user
  belongs_to :group
  
  validates_presence_of [:user_id, :group_id]

  # Request group membership
  def create_request
    if self.save
      message = {
        text: I18n.t('notifications.membership.new_request'),
        link: "/users/#{self.user_id}"
      }
      create_notification(message)
      UserMailer.sponsor_pending_membership_request(self.group.adult_sponsor, self.group, self.user).deliver
      true
    else
      false
    end
  end

  # Approve Membership
  def approve_membership
    user = User.find(self.user_id)
    user.group_id = self.group_id
    if user.save
      publish(user)
      self.destroy
      UserMailer.send_approved_notice(user, user.group).deliver
      true
    else
      false
    end
  end

  private

  def create_notification(message)
    sponsor = self.group.adult_sponsor
    notification = Notification.new(sponsor.id)
    notification.insert(message)
  end

  def publish(user)
    event = Chronologic::Event.new(
      key: "membership:#{self.user_id}:create",
      data: { type: "message", message: "#{user.name} joined the group" },
      timelines: ["group:#{self.group_id}"],
      objects: { user: "user:#{self.user_id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end
end
