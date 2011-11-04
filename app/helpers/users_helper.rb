module UsersHelper

  def show_membership_acceptance?(current_user, profile)
    if current_user.role == 'adult sponsor'
      pending_membership = Membership.where(user_id: profile.id, group_id: current_user.group_id).first
      if pending_membership
        accept = link_to "Accept Membership Request", group_membership_path(current_user.group.permalink,pending_membership.id), :method => "put", :class => "btn success"
        deny = link_to "Deny Membership Request", group_membership_path(current_user.group.permalink,pending_membership.id), :method => "delete", :class => "btn danger"
        return "<div id='membership-options'>#{accept} #{deny}</div>".html_safe
      end
    end
  end

end