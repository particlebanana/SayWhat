def set_status_and_role(status, role)
  @user.status = status
  @user.role = role
end

def login_admin
  @admin = FactoryGirl.create(:admin)
  sign_in @admin
end

def set_project_dates_for_reports
  @project.start_date = Date.today - 2.days
  @project.end_date = Date.today - 1.day
  @project.save
end

def build_decaying_group
  @group = Factory(:group)
  @captain_zissou = build_a_generic_admin(1)
  @captain_zissou.group = @group  
  @captain_zissou.save
  user = build_a_generic_user(1)
  user.group = @group
  user.save
  user
end

def setup_user_avatar
  @user = FactoryGirl.build(:user)
  @user.status = "active"
  @user.role = "member"
  @user.avatar = File.open(File.join(File.dirname(__FILE__), 'fixtures', 'profile.png'))
  @user.save!
end