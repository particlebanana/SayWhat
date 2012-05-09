# Send a notification to a Group Sponsor
# when a group member starts a grant application
class NotifySponsorGrantJob
  @queue = :email

  # Public: Send a notification to a Group Sponsor
  # when a group member starts a grant application
  #
  # This job manages notifiying a group sponsor when a 
  # group member starts a grant application. It will publish
  # a notification to their account and send them an email
  # to alert an action needs to be taken.
  #
  # host - The host name to send from
  # user_id - The user id of the member who started the application
  # grant_id - The id of the grant created by the member 
  #
  # Returns nothing. It's a worker task
  def self.perform(host, user_id, grant_id)
    user = User.find(user_id)
    grant = Grant.find(grant_id)
    project = grant.project
    group = project.group

    obj = self.new(host, user, grant, project, group)
    obj.send_email
    obj.create_notification
  end

  def initialize(host, user, grant, project, group)
    @host = host
    @user = user
    @grant = grant
    @project = project
    @group = group
  end

  # Sends an email notifying sponsor of new grant application
  def send_email
    GrantMailer.finalization_notification(@host, @user, @group, @project, @grant).deliver 
  end

  # Creates a notification
  # Informs the sponsor that someone in the group has applied for a grant
  def create_notification
    sponsor = @group.adult_sponsor
    notification = Notification.new(sponsor.id)
    notification.insert(I18n.t('notifications.grant.new_application'))
  end

end

