# Manage Tasks for a new Group Request
class NewGroupJob
  @queue = :email

  # Public: Manage Tasks for a new Group Request
  #
  # This job adds the group ID to the requesting user's record
  # and sends notifications to the site admins.
  #
  # user_id - The id of the requesting user
  # group_id - The id of the new Group
  #
  # Returns nothing. It's a worker task
  def self.perform(group_id, user_id)
    user = User.find(user_id)
    group = Group.find(group_id)
    obj = self.new(user, group)
    obj.join_group
    obj.send_notifications
  end

  def initialize(user, group)
    @user = user
    @group = group
  end

  # Add the Group ID to the user and set their role
  def join_group
    @user.group_id = @group.id
    @user.role = "adult sponsor"
    @user.save!
  end

  # Send group notifications
  def send_notifications
    GroupMailer.successful_group_request(@user, @group).deliver
    admins = User.site_admins
    admins.each {|e| GroupMailer.admin_pending_group_request(e, @group, @user).deliver }
  end
end