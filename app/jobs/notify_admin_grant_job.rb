# Send a notification to a Site Admins
# when a group submits a grant application
class NotifyAdminGrantJob
  @queue = :email

  # Public: Send a notification to Site Admins
  # when a group submits a grant application.
  #
  # This job manages notifiying site admins when a 
  # group submits a grant application. It will publish
  # a notification to each admins account and send them an email
  # to alert an action needs to be taken.
  #
  # grant_id - The id of the grant created by the member 
  #
  # Returns nothing. It's a worker task
  def self.perform(grant_id)
    grant = Grant.find(grant_id)
    project = grant.project
    group = project.group

    obj = self.new(grant, project, group)
    obj.send_emails
    obj.create_notifications
  end

  def initialize(grant, project, group)
    @grant = grant
    @project = project
    @group = group
  end

  # Sends an email notifying admins of a new grant application
  def send_emails
    User.site_admins.each do |admin|
      GrantMailer.notify_admin(admin.email, @grant).deliver
    end
  end

  # Creates a notification
  # Informs the admins that a group has applied for a grant
  def create_notifications
    message = "#{@group.display_name} #{I18n.t('notifications.grant.admin_notify')}"

    User.site_admins.each do |admin|
      notification = Notification.new(admin.id)
      notification.insert(message)
    end
  end

end

