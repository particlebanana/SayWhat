class Membership < ActiveRecord::Base
  
  # Handles Group Membership Request
  belongs_to :user
  belongs_to :group
  
  validates_presence_of [:user_id, :group_id]

  # Request group membership
  def create_request
    if self.save
      message = {
        text: I18n.t('notifications.membership.new_request'),
        link: "/users/#{self.user_id}"
      }
      async_create_notification(message)
      true
    else
      false
    end
  end

  # Approve Membership
  def approve_membership
    user = User.find(self.user_id)
    user.group_id = self.group_id
    if user.save
      async_approve_membership()
      true
    else
      false
    end
  end

  # Deny Membership
  def deny_membership
    begin
      async_deny_membership()
      return true
    rescue
      return false
    end
  end

  private

  def async_create_notification(message)
    sponsor = self.group.adult_sponsor
    requestor = self.user_id
    Resque.enqueue(NewMembershipRequest, self.id, sponsor.id, message[:text], message[:link], requestor)
  end

  def async_approve_membership
    group = Group.find(self.group)
    Resque.enqueue(ManageGroupMembership, self.user_id, group.id, 'approve')
  end

  def async_deny_membership
    group = Group.find(self.group)
    Resque.enqueue(ManageGroupMembership, self.user_id, group.id, 'deny')
  end
end
