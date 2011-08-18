
# Creates a membership request message
Factory.define :member_request, :class => Message do |r|
  r.message_type "request"
  r.author "Han Solo"
  r.subject "New Membership Request"
  r.content "You have a new membership request from Gaylord Focker"
end

# Creates a generic message
Factory.define :message do |m|
  m.message_type "message"
  m.author "Han Solo"
  m.subject "Generic Message"
  m.content "This is a generic message"
end