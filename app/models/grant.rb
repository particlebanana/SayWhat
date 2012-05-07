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
    Resque.enqueue(NotifySponsorGrantJob, host, requestor.id, self.id)
  end

  # Sends site admin an email
  # Informs that a group has applied for an application
  def notify_admin_of_application
    Resque.enqueue(NotifyAdminGrantJob, self.id)
  end

  # Approves a grant, sends the sponsor an email and a notification
  # Returns True or False
  def approve
    self.status = 'approved'
    if self.save
      Resque.enqueue(ManageGrantApplicationJob, self.id, 'approve')
      true
    else
      false
    end
  end

  # Denies a grant, sends the sponsor an email and a notification
  # Requires a reason object
  # Returns True or False
  def deny(reason)
    if reason.is_a?(Hash) && self.destroy
      Resque.enqueue(ManageGrantApplicationJob, self.id, 'deny', reason['email_text'])
      true
    else
      false
    end
  end
end