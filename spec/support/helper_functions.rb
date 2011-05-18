def set_status_and_role(status, role)
  @user.status = status
  @user.role = role
end

def login_admin
  @admin = Factory.create(:admin)
  sign_in @admin
end

def set_project_dates_for_reports
  @project.start_date = Date.today - 2.days
  @project.end_date = Date.today - 1.day
  @project.save
end

def build_decaying_group
  @group = Factory(:group)
  @admin = Factory.build(:user, :email => "admin@gmail.com")
  @admin.status = "active"
  @admin.role = "adult sponsor"
  @admin.group = @group  
  @admin.save
  user = Factory.build(:user_input, :email => "billy.bob@gmail.com")
  user.status = 'active'
  user.role = 'member'
  user.group = @group
  user.save
end