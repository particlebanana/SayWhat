# Approve/Deny Group Creation
class ManageGroupRequestJob
  @queue = :feed

  # Public: Manage a group creation request
  #
  # This job manages a request to create a group. When an admin
  # decides to either approve or deny a new group a few things
  # should happen.
  #
  # If approved it should create a new feed object for the group,
  # subscribe the sponsor to the group timeline and create a new
  # timeline event.
  #
  # If either approved or denied an email should be sent to the requesting
  # user of the decision.
  #
  # If denied the user should be downranked to a "member" and have
  # the group_id property removed.
  #
  # user_id - The user id of the member requesting access
  # group_id - The group id the member is requesting access to
  #
  # Returns nothing. It's a worker task
  def self.perform(user_id, group_id, data, method)
    group = Group.find(group_id)
    user = User.find(user_id)

    obj = self.new(user, group)
    if method == 'approve'
      obj.create_object_key
      obj.subscribe_user_to_group
      obj.create_approved_group_timeline_event
      obj.send_approved_email_notifications(data)
    elsif method == 'deny'
      obj.reset_user
      obj.send_denied_email_notification(data)
    end
  end

  def initialize(user, group)
    @user = user
    @group = group
  end

  # Create an object in the Activity Feed
  def create_object_key
    $feed.record("group:#{@group.id}", { id: @group.permalink, name: @group.display_name } )
  end

  # Subscribe the User to the Group Timeline
  def subscribe_user_to_group
    $feed.subscribe("user:#{@user.id}", "group:#{@group.id}")
  end

  # Add an event to global timeline when a group is approved
  def create_approved_group_timeline_event
    event = Chronologic::Event.new(
      key: "group:#{@group.id}:create",
      data: { type: "message", message: "#{@user.name} created the group #{@group.display_name}" },
      timelines: ["global_feed", "group:#{@group.id}", "user:#{@user.id}"],
      objects: { user: "user:#{@user.id}", group: "group:#{@group.id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end

  # Send approved email notification
  def send_approved_email_notifications(url)
    GroupMailer.send_approved_notice(@user, @group, url).deliver
  end

  # Send denied email notification
  def send_denied_email_notification(text)
    GroupMailer.send_denied_notice(@user, @group, text).deliver
  end

  # Clear Group from user
  def reset_user
    @user.group = nil
    @user.role = "member"
    @user.save
  end
end