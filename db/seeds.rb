
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name == 'system.indexes'}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.new(:first_name => 'Ruler', :last_name => "Of The World", :email => 'cs62@txstate.edu', :password => 'admin123', :password_confirmation => 'admin123')
user.role = 'admin'
user.status = 'active'
user.save!
puts 'New user created: ' << user.email
puts 'Password is admin123'
