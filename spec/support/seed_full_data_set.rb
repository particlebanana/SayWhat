def seed_full_data_set
  3.times do |count|
    group = Factory.build(:group, :display_name => "group_" + count.to_s)
    admin = build_a_generic_admin(count)
    user = build_a_generic_user(count)
    group.users << admin
    group.users << user
    admin.save
    user.save
    3.times do |i|
      project = build_a_generic_project(i)
      group.projects << project
      project.save
    end
    group.save
  end
end

def build_a_generic_admin(i)
  admin = Factory.build(:user, :email => "admin_" + i.to_s + "@gmail.com")
  admin.status = "active"
  admin.role = "adult sponsor"
  admin
end

def build_a_generic_user(i)
  user = Factory.build(:user, :email => "member_" + i.to_s + "@gmail.com")
  user.status = "active"
  user.role = "member"
  user
end

def build_a_generic_project(i)
  focus_array = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects']
  audience_array = ['Elementary Students', 'Middle School Students', 'High School Students']
  project = Factory.build(:project, :display_name => "project_" + i.to_s, :focus => focus_array[i], :audience => audience_array[i])
end

def seed_messages(count)
  count.to_i.times do
    message = Factory.build(:message)
    @user.messages << message
    @user.save!
  end
end