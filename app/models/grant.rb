class Grant < ActiveRecord::Base

  belongs_to :project

  attr_protected [:member, :status]

  validates_presence_of [:status, :member, :planning_team, :serviced, :goals, :funds_use, :partnerships, :resources]

  # Scopes
  def self.completed
    where(status: "completed")
  end

  def self.approved
    where(status: "approved")
  end

  # Sends group sponsor an email and creates a notification
  # Informs that someone in the group has applied for a grant
  def notify_sponsor_of_application(host, requestor)
    GrantMailer.finalization_notification(host, requestor, self.project.group, self.project, self).deliver 
    message = {
      text: I18n.t('notifications.grant.new_application'),
      link: "/groups/#{self.project.group.permalink}/projects/#{self.project.id}/grants/#{self.id}/edit"
    }
    create_notification(message)
  end

  # Sends site admin an email
  # Informs that a group has applied for an application
  def notify_admin_of_application
    User.site_admins.each do |admin|
      GrantMailer.notify_admin(admin.email, self).deliver
    end
  end

  # Approves a grant, sends the sponsor an email and a notification
  # Returns True or False
  def approve
    self.status = 'approved'
    if self.save
      GrantMailer.grant_approved(self).deliver
      messages = build_approved_messages
      create_notification(messages[:notification])
      self.project.publish_to_feed(messages[:event][:key], messages[:event][:text])
      true
    else
      false
    end
  end

  # Denies a grant, sends the sponsor an email and a notification
  # Requires a reason object
  # Returns True or False
  def deny(reason)
    this = self
    messages = build_denied_messages
    if reason.is_a?(Hash) && self.destroy
      GrantMailer.grant_denied(this, reason['email_text']).deliver
      create_notification(messages[:notification])
      true
    else
      false
    end
  end

  private

  def create_notification(message)
    sponsor = self.project.group.adult_sponsor
    notification = Notification.new(sponsor.id)
    notification.insert(message)
  end

  # Builds the text, links, NoSQL keys, etc for an approved grant
  def build_approved_messages
    messages = {
      notification: {
        text: I18n.t('notifications.grant.approved'),
        link: "/groups/#{self.project.group.permalink}/projects/#{self.project.id}"
      },
      event: {
        key: "project:#{self.project.id}:grant:#{self.id}:approved",
        text: "#{self.project.display_name} has been awarded a mini-grant!"
      }
    }
  end

  def build_denied_messages
    messages = {
      notification: {
        text: I18n.t('notifications.grant.denied'),
        link: "/groups/#{self.project.group.permalink}/projects/#{self.project.id}"
      }
    }
  end
end