
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
  u.username 'hansolo'
  u.email 'han.solo@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder' 
end

# Creates an admin user
Factory.define :admin, :class => "user" do |u|
  u.first_name 'administrator'
  u.last_name 'of the world!'
  u.username 'admin'
  u.email 'admin@awesome.com'
  u.password 'admin123' 
  u.password_confirmation 'admin123' 
  u.status 'active'
  u.role 'admin'
end