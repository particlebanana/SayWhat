
# Creates a base user
Factory.define :user do |u|
  u.name 'Keith Stone'
  u.username 'kstone'
  u.email 'keith.stone@awesome.com'
  u.password 'keithstone' 
  u.role 'admin' 
end

# Creates an admin user
Factory.define :admin, :class => "user" do |u|
  u.name 'administrator'
  u.username 'admin'
  u.email 'admin@awesome.com'
  u.password 'admin123' 
  u.role 'admin'  
end