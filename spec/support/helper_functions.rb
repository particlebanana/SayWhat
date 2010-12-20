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