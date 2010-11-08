
# Creates an active user
Factory.define :user do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.username 'hansolo'
  u.email 'han.solo@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder' 
  u.role 'adult sponsor'
  u.status 'active' 
end

# Creates an admin user
Factory.define :admin, :class => "user" do |u|
  u.first_name 'administrator'
  u.last_name 'of the world!'
  u.username 'admin'
  u.email 'admin@awesome.com'
  u.password 'admin123' 
  u.password_confirmation 'admin123' 
  u.role 'admin'  
  u.status 'active'
end


# Creates a pending user
Factory.define :pending_user, :class => "user" do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.username 'hansolo'
  u.email 'han.solo@gmail.com'
  u.role 'adult sponsor' 
  u.status 'pending'
end


# Creates a user with status of "setup"
Factory.define :setup_user, :class => "user" do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.username 'hansolo'
  u.email 'han.solo@gmail.com'
  u.role 'adult sponsor' 
  u.status 'setup'
end