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

def build_report_params
  report_params = {
    :permalink => @group.permalink, 
    :name => @project.name,
    :report => {
      :number_of_youth_reached  => "10",
      :number_of_adults_reached => "10",
      :percent_male => "5",
      :percent_female => "5",
      :percent_african_american => "5",
      :percent_asian => "5",
      :percent_caucasian => "5",
      :percent_hispanic => "5",
      :percent_other => "80",
      :money_spent => "$100+",
      :prep_time => "1 month +",
      :other_resources => "Lasers",
      :comment => "This was a success! We can blow up planets!"
    }
  }
end