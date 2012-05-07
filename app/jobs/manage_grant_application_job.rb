# Approve/Deny Grant Application
class ManageGrantApplicationJob
  @queue = :feed

  # Public: Manage a grant application request
  #
  # This job manages a grant application request. When an admin
  # decides to either approve or deny a grant a few things
  # should happen.
  #
  # If approved it should create a notification for the groups
  # adult sponsor and publish to the group and project feeds.
  #
  # If either approved or denied an email should be sent to the requesting
  # user of the decision.
  #
  # If denied a notification should be sent to the group's adult
  # sponsor notifying them of the decision.
  #
  # grant_id - The id of the grant being managed
  # method - approve/deny
  # data - optional, reason for denied used with a deny request
  #
  # Returns nothing. It's a worker task
  def self.perform(grant_id, method, data=nil)
    grant = Grant.find(grant_id)

    obj = self.new(grant)
    if method == 'approve'
      obj.create_approved_notification
      obj.publish_to_feed
      obj.send_approved_email
    elsif method == 'deny'
      obj.create_denied_notification
      obj.send_denied_email(data)
    end
  end

  def initialize(grant)
    @grant = grant
    @project = @grant.project
    @group = @project.group
    @user = @group.adult_sponsor
  end


  # Creates an approved notification
  # Informs the sponsor their grant has been approved
  def create_approved_notification
    message = {
      text: I18n.t('notifications.grant.approved'),
      link: "/groups/#{@group.permalink}/projects/#{@project.id}"
    }

    notification = Notification.new(@user.id)
    notification.insert(message)
  end

  # Creates a denied notification
  # Informs the sponsor their grant has been denied
  def create_denied_notification
    message = {
      text: I18n.t('notifications.grant.denied'),
      link: "/groups/#{@group.permalink}/projects/#{@project.id}"
    }

    notification = Notification.new(@user.id)
    notification.insert(message)
  end

  # Publish to Project and Group feed
  def publish_to_feed
    event = Chronologic::Event.new(
      key:  "project:#{@grant.project.id}:grant:#{@grant.id}:approved",
      data: { type: "message", message: "#{@project.display_name} has been awarded a mini-grant!"},
      timelines: ["group:#{@group.id}", "project:#{@project.id}"],
      objects: { group: "group:#{@group.id}", project: "project:#{@project.id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end

  # Send approved email
  def send_approved_email
    GrantMailer.grant_approved(@grant).deliver
  end

  # Send denied email
  def send_denied_email(data)
    GrantMailer.grant_denied(@grant, data).deliver
  end

end