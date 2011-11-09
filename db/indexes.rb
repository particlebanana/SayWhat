require 'mongo'

conn = Mongo::Connection.new

#
# Notification Indexes
#
db = conn.db('saywhat_notifications').create_collection('notifications')
db.create_index('user')
db.create_index('notifications.id')

puts "created indexes on saywhat_notifications"


#
# Timeline Indexes - Should be moved to Chronologic
#
db = conn.db('SaywhatActivity').create_collection('Event')
db.create_index('token')

db = conn.db('SaywhatActivity').create_collection('Object')
db.create_index('id')

puts "created indexes on SaywhatActivity"

conn.close
