def build_group_request
  request = {
    :group => {
      :display_name => "Han Shot First",
      :city => "Mos Eisley",
      :organization => "Free Greedo",
      :user => {
        :first_name => "Luke",
        :last_name => "Skywalker",
        :email => "luke.skywalker@gmail.com"
      }
    }
  }
end

def build_project_params
  project = {
    :permalink => @group.permalink,
    :project => {
      :display_name =>  "Build Death Star",
      :location => "Outer Space",
      :start_date => "11-11-2011",
      :end_date => "11-12-2011",
      :focus => "Alderaan",
      :audience => "People of Aldreaan...for a flash",
      :goal => "Destroy planets",
      :involves => "Stormtroopers, Sith Lords, Vader, A Big Laser",
      :description => "A Top Secret project"
    }
  }
end

def build_comment_params
  comment_params = {
    :permalink => @group.permalink, 
    :name => @project.name, 
    :comment_id => @comment.id.to_s,
    :comment => {
      :comment => "This is an updated comment"
    }
  }
end