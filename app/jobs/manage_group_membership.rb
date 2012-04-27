# Approve/Deny membership to a Group
class ManageGroupMembership
  @queue = :feed

  # Public: Manage a group membership request
  #
  # This job manages a group membership request. If the
  # request was accepted it should publish the event to the
  # group timeline and send the new member an email.
  # 
  # Both responses should clear out the group sponsor's notification
  # and remove the record from the memberships table.
  #
  # user_id - The user id of the member requesting access
  # group_id - The group id the member is requesting access to
  #
  # Returns nothing. It's a worker task
  def self.perform(user_id, group_id, method)
    group = Group.find(group_id)
    user = User.find(user_id)

    obj = self.new(user, group)
    if method == 'approve'
      obj.subscribe_user_to_group
      obj.publish_to_timeline
      obj.send_notifications
      
      # Send the new member an email
      UserMailer.send_approved_notice(user, group).deliver
    end

    # Destroy the membership record
    obj.destroy_membership_items
  end

  def initialize(user, group)
    @user = user
    @group = group
  end

  # Publishes the event to a groups timeline
  def publish_to_timeline
    event = Chronologic::Event.new(
      key: "membership:#{@user.id}:create",
      data: { type: "message", message: "#{@user.name} joined the group" },
      timelines: ["group:#{@group.id}"],
      objects: { user: "user:#{@user.id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end

  # Sends all the members of the group a notification
  # except the sponsor who approved the member
  def send_notifications
    sponsor = @group.adult_sponsor
    @group.users.each do |member|
      # Don't send to the new member or the sponsor
      if member.id != @user.id && member.id != sponsor.id
        notification = Notification.new(member.id)
        message = {
          text: "#{@user.name} #{I18n.t('notifications.membership.approved_request')}",
          link: "/users/#{@user.id}"
        }
        notification.insert(message)
      elsif member.id == @user.id
        notification = Notification.new(member.id)
        message = {
          text: "#{I18n.t('notifications.membership.approved_member')}",
          link: "/groups/#{@group.permalink}"
        }
        notification.insert(message)
      end
    end
  end

  # Subscribe the User to the Group Timeline
  def subscribe_user_to_group
    $feed.subscribe("user:#{@user.id}", "group:#{@group.id}")
  end

  # Remove the Sponsor's Notification and Membership Record
  def destroy_membership_items
    begin
      sponsor = @group.adult_sponsor
      membership = Membership.where(:user_id => @user.id, :group_id => @group.id).first
      Notification.destroy(sponsor.id, membership.notification)
      membership.destroy
      return true
    rescue
      return false
    end
  end
end