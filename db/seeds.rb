
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name == 'system.indexes'}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.new :username => 'admin', :name => 'administrator', :email => 'admin@test.com', :password => 'admin123', :password_confirmation => 'admin123'
user.role = 'admin'
user.save
puts 'New user created: ' << user.username
puts 'Password is admin123'
