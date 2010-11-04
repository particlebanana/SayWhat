
# Creates a base user
Factory.define :user do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.username 'hansolo'
  u.email 'han.solo@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder' 
  u.role 'sponsor' 
end

# Creates an admin user
Factory.define :admin, :class => "user" do |u|
  u.name 'administrator'
  u.username 'admin'
  u.email 'admin@awesome.com'
  u.password 'admin123' 
  u.password_confirmation 'admin123' 
  u.role 'admin'  
end