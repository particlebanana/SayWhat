
def build_group_with_admin
  @group = Factory.build(:group)
  @admin = Factory.build(:user, :email => "admin@gmail.com")
  @admin.status = "active"
  @admin.role = "adult sponsor"
  @group.users << @admin  
  @admin.save
  @user = Factory.build(:user, :email => "member@gmail.com")
  @user.status = "active"
  @user.role = "member"
  @group.users << @user
  @user.save
  @group.save
end


def build_project
  @project = Factory.build(:project)
  @group.projects << @project
  @project.save
  @group.save
end

def build_completed_project
  project = Factory.build(:project, :display_name => "Completed Project")
  project.start_date = Date.today - 2.days
  project.end_date = Date.today - 1.day
  @group.projects << project
  project.save
  @group.save
end

def add_comment
  @comment = Factory.build(:comment)
  @user.comments << @comment
  @project.comments << @comment
  @comment.save!
end

def create_project_cache
  @project_cache = ProjectCache.new(
    :group_id => @group.id.to_s, 
    :project_id => @project.id.to_s,
    :group_name => @group.display_name, 
    :group_permalink => @group.name, 
    :project_name => @project.display_name, 
    :project_permalink => @project.name, 
    :focus => @project.focus, 
    :audience => @project.audience,
    :start_date => Date.today - 1.day,
    :end_date => Date.today
  )
  @project_cache.group_id = @group.id.to_s
  @project_cache.project_id = @project.id.to_s
end

def seed_additional_group
  group = Factory.build(:group, :display_name => "Trade Federation", :permalink => "trade+federation")
  group.save!
  project = Factory.build(:project, :display_name => "Join the empire")
  group.projects << project
  project.save!
  user = Factory.build(:user, :email => "add_member@gmail.com")
  user.status = "active"
  user.role = "member"
  group.users << user
  user.save!
  group.save!
  user
end