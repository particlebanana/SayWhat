
def build_group_with_admin
  @group = FactoryGirl.build(:group)
  @group.save!
  @admin = FactoryGirl.build(:user, :email => "admin@gmail.com")
  @admin.status = "active"
  @admin.role = "adult sponsor"
  @admin.group = @group
  @admin.save
  @user = FactoryGirl.build(:user, :email => "member@gmail.com")
  @user.status = "active"
  @user.role = "member"
  @user.group = @group
  @user.save
end


def build_project
  @project = FactoryGirl.build(:project)
  @group.projects << @project
  @project.save
  @group.save
end

def build_completed_project
  project = FactoryGirl.build(:project, :display_name => "Completed Project")
  project.start_date = Date.today - 2.days
  project.end_date = Date.today - 1.day
  @group.projects << project
  project.save
  @group.save
end

def add_comment
  @comment = FactoryGirl.build(:comment)
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
  group = FactoryGirl.build(:group, :display_name => "Trade Federation", :permalink => "trade+federation")
  group.save!
  project = FactoryGirl.build(:project, :display_name => "Join the empire")
  group.projects << project
  project.save!
  user = FactoryGirl.build(:user, :email => "add_member@gmail.com")
  user.status = "active"
  user.role = "member"
  group.users << user
  user.save!
  group.save!
  user
end