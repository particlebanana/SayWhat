module GroupsHelper

  def group_page_header(group)
    html = "<hgroup>"
    if current_user && current_user.group && current_user.group.id == group.id && current_user.sponsor?
      html << "
        <div class='main-heading cf'>
          <h1 class='heading'>#{group.display_name}</h1>
          #{link_to 'edit group', edit_group_path(group.permalink), :class => 'btn'}
        </div>
        <h6>#{group.organization} / #{group.city}, TX</h6>"
    else
      html << "
        <div class='main-heading cf'>
          <h1 class='heading'>#{group.display_name}</h1>
        </div>
        <h6>#{group.organization} / #{group.city}, TX</h6>"
    end
    html << "</hgroup>"
  end
  
end