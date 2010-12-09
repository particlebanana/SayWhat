def set_status_and_role(status, role)
  @user.status = status
  @user.role = role
end

def login_admin
  @admin = Factory.create(:admin)
  sign_in @admin
end