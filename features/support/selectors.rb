module HtmlSelectorsHelper
  def selector_for(scope)
    case scope
      
    when /the body/
      "html > body"
    
    when /the pending groups list/
      "ul"
      
    when /the page title/
      "#groupContent header h1"
      
    when /the page header/
      "header"
      
    when /the form fields/
      "form > p"
      
    when /the notice/
      "p.notice"
      
    when /the pending members list/
      "ul#pendingMembers"
      
    when /the youth sponsor/
      "li#youthSponsor"
      
    when /the projects list/
      "ul#projectsList li"
      
    when /Recent Projects/
      "ul#recentProjects"
      
    when /Completed Projects/
      "ul.completed"
      
    when /Upcoming Projects/
      "ul.upcoming"
    
    else
      raise "Can't find mapping from \"#{scope}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelper)