# Manage Fanout Notifications on Comment Post
class NotificationFanoutJob
  @queue = :notifications

  # Public: Manage the fanout of notifications
  #
  # This job fans out the notifications to subscribed
  # members when a new comment is made.
  #
  # example: A comment is made on a group timeline, so
  # a notification is sent to all the group members that
  # there is new activity in their group.
  #
  # user_id - The id of the user who created the comment
  # commentType - one of [`project`, `group`, `child`]
  # object - the id of the object being commented on
  #          (ex. group_id, project_id, comment_parent)
  #
  # Returns nothing. It's a worker task
  def self.perform(user_id, commentType, object_id)
    user = User.find(user_id)
    obj = self.new(user, commentType, object_id)

    # Alert the entire group if commentType is
    # either `project` or `group`. This means it's a
    # new comment and not an existing one.
    if commentType == 'project' || commentType == 'group'
      obj.alert_group
    end
  end

  def initialize(user, commentType, object_id)
    @user = user
    @commentType = commentType
    if @commentType == 'project'
      @project = Project.find(object_id)
      @group = @project.group
    elsif @commentType == 'group'
      @group = Group.find(object_id)
    elsif @commentType == 'child'
      event = get_sub_events(object_id)
      event_users = filter_subevents(event["subevents"])
      alert_users(event_users)
    end
  end

  # Build the notification based on the comment type to be
  # fanned out to the various subscribed users.
  def build_message
    case @commentType
    when 'project'
      message = "#{@user.name} posted on the project: #{@project.display_name}."
    when 'group'
      message = "#{@user.name} created a new post in your group"
    when 'child'
      message = "#{@user.name} responded to your comment"
    end

    message
  end

  # Send a notification to every member of the group
  def alert_group
    message = build_message
    @group.users.each do |user|
      if user.id != @user.id
        alert_user(user.id, message)
      end
    end
  end

  def alert_users(users)
    message = build_message
    users.each do |user|
      if user.to_i != @user.id
        alert_user(user.to_i, message)
      end
    end
  end

  private

  def alert_user(user_id, message)
    notification = Notification.new(user_id)
    notification.insert(message)
  end

  def get_sub_events(object)
    $feed.fetch("/event/#{object}")
  end

  def filter_subevents(events)
    users = []
    events.each do |event|
      users << event["objects"]["user"]["id"]
    end

    users.uniq
  end
end