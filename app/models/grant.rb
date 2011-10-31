class Grant < ActiveRecord::Base

  belongs_to :project

  attr_protected [:member, :status]

  validates_presence_of [:status, :member, :planning_team, :serviced, :goals, :funds_use, :partnerships, :resources]

  def send_notification
    sponsor = self.project.group.adult_sponsor
    notification = Notification.new(sponsor.id)
    text = I18n.t 'notifications.grant.new_application'
    link = "/groups/#{self.project.group.permalink}/projects/#{self.project.id}/grants/#{self.id}/edit"
    notification.insert(text, link)
  end
end