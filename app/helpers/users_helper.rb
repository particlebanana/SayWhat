module UsersHelper

  def show_membership_acceptance?(current_user, profile)
    if current_user.role == 'adult sponsor'
      pending_membership = Membership.where(user_id: profile.id, group_id: current_user.group_id).first
      if pending_membership
        link = link_to "Accept Membership Request", group_membership_path(current_user.group.permalink,pending_membership.id), :method => "put", :class => "btn success"
        return link
      end
    end
  end

end