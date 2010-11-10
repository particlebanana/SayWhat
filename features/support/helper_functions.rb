
def create_pending_group(name)
  @group = Factory.build(:pending_group, :display_name => name)
  @group.status = 'pending'
  @user = Factory.build(:user_input)
  @user.status = 'pending'
  @user.role = 'pending'
  @group.users << @user
  @group.save
end

def create_setup_group(name)
  @group = Factory.build(:pending_group, :display_name => name)
  @group.status = 'active'
  @user = Factory.build(:user_input)
  @user.status = 'setup'
  @user.role = 'adult sponsor'
  @group.users << @user
  @group.save
end