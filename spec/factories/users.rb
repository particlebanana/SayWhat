
# User Input Fields
Factory.define :user_input, :class => "user" do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.email 'han.solo@gmail.com'
end

# Creates an active user
Factory.define :user do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.email 'han.solo@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder' 
end

# Creates an adult sponsor
Factory.define :adult_sponsor, :class => "user" do |u|
  u.first_name 'Jabba'
  u.last_name 'The Hutt'
  u.email 'jabba@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder' 
  u.status 'active'
  u.role 'adult sponsor'
end

# Creates a youth sponsor
Factory.define :youth_sponsor, :class => "user" do |u|
  u.first_name 'Chewbaca'
  u.last_name 'The Copilot'
  u.email 'chewy@gmail.com'
  u.password 'baaaaaaaaaaa' 
  u.password_confirmation 'baaaaaaaaaaa' 
  u.status 'active'
  u.role 'youth sponsor'
end

# Creates a pending member
Factory.define :pending_member, :class => "user" do |u|
  u.first_name 'Bobba'
  u.last_name 'Fett'
  u.email 'bobba@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder' 
  u.status 'setup'
  u.role 'member'
end

# Creates an admin user
Factory.define :admin, :class => "user" do |u|
  u.first_name 'administrator'
  u.last_name 'of the world!'
  u.email 'admin@awesome.com'
  u.password 'admin123' 
  u.password_confirmation 'admin123' 
  u.status 'active'
  u.role 'admin'
end