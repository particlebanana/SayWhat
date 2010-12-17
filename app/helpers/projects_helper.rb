module ProjectsHelper
  
  def list_projects(projects)
    if projects.any?
      render 'shared/projects', :projects => projects
    end
  end
  
  def list_projects_from_cache(projects)
    if projects.any?
      render 'shared/project_index', :projects => projects
    end
  end
  
  def project_photo(project, cache=false)
    if cache 
      link_to image_tag(project.profile_photo), "/groups/#{project.group_permalink}/projects/#{project.project_permalink}"
    else
      link_to image_tag(project.profile_photo_url(:small)), "/groups/#{project.group.permalink}/projects/#{project.name}"
    end
  end
    
  def project_link(project)
    link_to h(project.display_name), "/groups/#{project.group.permalink}/projects/#{project.name}"
  end
  
end