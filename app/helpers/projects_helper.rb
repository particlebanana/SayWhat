module ProjectsHelper
  
  def list_projects(projects, css="")
    if projects.any?
      render 'shared/projects', :projects => projects, :css => css
    end
  end
  
  def list_projects_from_cache(projects)
    if projects.any?
      render 'shared/project_index', :projects => projects
    end
  end
  
  def project_photo(project)
    link_to image_tag(project.profile.url(:small), :width => 200, :height => 100), "/groups/#{project.group.permalink}/projects/#{project.name}"
  end
    
  def project_link(project)
    link_to h(project.display_name), "/groups/#{project.group.permalink}/projects/#{project.name}"
  end
  
end