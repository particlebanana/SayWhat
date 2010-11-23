
def create_pending_group(name)
  @group = Factory.build(:pending_group, :display_name => name)
  @group.status = 'pending'
  @user = Factory.build(:user_input)
  @user.status = 'pending'
  @user.role = 'pending'
  @group.users << @user
  @user.save
  @group.save
end

def create_setup_group(name)
  @group = Factory.build(:pending_group, :display_name => name)
  @group.status = 'active'
  @user = Factory.build(:user_input)
  @user.status = 'setup'
  @user.role = 'adult sponsor'
  @group.users << @user
  @user.save
  @group.save
end

def create_group(name)
  @group = Factory.build(:group, :display_name => name)
  @group.status = 'active'
  @user = Factory.build(:user)
  @user.status = 'active'
  @user.role = 'adult sponsor'
  @group.users << @user
  @user.save
  @group.save
end

def create_user(email)
  @group = Factory.build(:group, :display_name => 'Evil Empire')
  @group.status = 'active'
  @user = Factory.build(:user, :email => email)
  @user.status = 'active'
  @user.role = 'adult sponsor'
  @group.users << @user
  @user.save
  @group.save
  @user
end

def create_setup_user
  @group = Factory.build(:group, :display_name => 'Evil Empire')
  @group.status = 'active'
  @user = Factory.build(:user)
  @user.status = 'setup'
  @user.role = 'member'
  @group.users << @user
  @user.save
  @group.save
end