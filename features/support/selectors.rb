module HtmlSelectorsHelper
  def selector_for(scope)
    case scope
      
    when /the body/
      "html > body"
    
    when /the pending groups list/
      "ul"
      
    when /the page title/
      "h2"
      
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
    
    else
      raise "Can't find mapping from \"#{scope}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelper)