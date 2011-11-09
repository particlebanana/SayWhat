module ProjectsHelper
  
  def project_page_header(project)
    html = "<hgroup>"
    if can? :update, project
      html << "
        <div class='main-heading cf'>
          <h1 class='heading'>#{project.display_name}</h1>
          #{link_to 'edit project', edit_group_project_path(project.group.permalink, project), :class => 'btn'}
        </div>
        <h6>#{project.group.display_name}</h6>"
    else
      html << "
        <div class='main-heading cf'>
          <h1 class='heading'>#{project.display_name}</h1>
        </div>
        <h6>#{project.group.display_name}</h6>"
    end
    html << "</hgroup>"
  end
  
end