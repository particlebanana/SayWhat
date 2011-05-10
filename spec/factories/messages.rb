
# Creates a membership request message
Factory.define :member_request, :class => Message do |r|
  r.message_type "request"
  r.message_author "Han Solo"
  r.message_subject "New Membership Request"
  r.message_content "You have a new membership request from Gaylord Focker"
end

# Creates a generic message
Factory.define :message do |m|
  m.message_type "message"
  m.message_author "Han Solo"
  m.message_subject "Generic Message"
  m.message_content "This is a generic message"
end