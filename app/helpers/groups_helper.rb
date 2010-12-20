module GroupsHelper
  
  def group_link(group)
    link_to h(group.display_name), "/groups/#{group.permalink}"
  end
  
end