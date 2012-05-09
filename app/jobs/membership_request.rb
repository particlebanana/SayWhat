class MembershipRequest
  @queue = :email

  # Public: Send an email to a group sponsor when
  # a user requests group membership
  #
  # membership_id - INT, the id of the membership request
  #
  # Returns nothing. It's a worker task
  def self.perform(membership_id)
    membership = Membership.find(membership_id)
    group = Group.find(membership.group_id)
    sponsor = group.adult_sponsor
    user = User.find(membership.user_id)

    send_sponsor_email(sponsor, group, user)
  end

  def self.send_sponsor_email(sponsor, group, user)
    UserMailer.sponsor_pending_membership_request(sponsor, group, user).deliver
  end
end

