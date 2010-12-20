module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    
    when /the login page/
      '/users/sign_in'
        
    when /request new group page/
      "/groups/new"
      
    when /the pending groups page/
      '/groups/pending_groups'
      
    when /\/setup\?auth_token=/
      '/setup'

    when /the setup page/
      '/setup'
      
    when /the permalink setup page/
      '/setup/permalink'
      
    when /my group page/
      "/groups/#{@group.permalink}"
      
    when /the groups home page/
      "/groups/#{@group.permalink}"
      
    when /my profile settings page/
      '/settings/profile'
      
    when /my password settings page/
      '/settings/password'
      
    when /the request group membership page/
      "/groups/#{@group.permalink}/join"
      
    when /the pending members page/
      "/groups/#{@group.permalink}/pending_memberships"
      
    when /the invite member page/
      "/groups/#{@group.permalink}/invite"
      
    when /my groups projects page/
      "/groups/#{@group.permalink}/projects"
      
    when /the groups projects page/
      "/groups/#{@group.permalink}/projects"
      
    when /the project page/
      "/groups/#{@group.permalink}/projects/#{@project.name}"
      
    when /the all projects page/
      "/projects"

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
