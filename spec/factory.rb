Factory.define :user do |u|
  u.first_name 'Han'
  u.last_name 'Solo'
  u.email 'han.solo@gmail.com'
  u.password 'nerfherder' 
  u.password_confirmation 'nerfherder'
  u.status 'active'
  u.role 'member'
end

Factory.define :group do |g|
  g.display_name "Jedi Knights"
  g.city "Mos Eisley"
  g.organization "Rebel Alliance"
  g.description "An organization of Vader haters."
  g.permalink "jedi-knights"
  g.status "active"
  g.esc_region "1"
  g.dshs_region "1"
  g.area "central texas"
end

Factory.define :project do |p|
  p.display_name "Build Death Star"
  p.location "Outer Space"
  p.start_date "11-11-2011"
  p.end_date "11-12-2011"
  p.focus "Alderaan"
  p.audience "People of Aldreaan...for a flash"
  p.goal "Destroy planets"
  p.involves "Stormtroopers, Sith Lords, Vader, A Big Laser"
  p.description "A Top Secret project"
end

Factory.define :comment do |c|
  c.user_id 1
  c.project_id 1
  c.comment "What planet will be destroyed first?"
end

Factory.define :message do |m|
  m.message_type "message"
  m.author "Han Solo"
  m.subject "Generic Message"
  m.content "This is a generic message"
end

Factory.define :grant do |g|
  g.group_name "Rebel Alliance"
  g.check_payable "Han Solo"
  g.adult_name "Han Solo"
  g.adult_phone "123-456-7890"
  g.adult_email "han.solo@gmail.com"
  g.adult_address "123 Falcon Dr"
  g.youth_name "Luke Skywalker"
  g.youth_email "luke.skywalker@gmail.com"
  g.project_description "Blow Up The Deathstar"
  g.project_when "ASAP"
  g.project_where "Space"
  g.project_who "Rebel Alliance"
  g.project_serve "Humanity"
  g.project_goals "Destroy the empire"
  g.funds_need "$500"
  g.community_partnerships "galaxy"
  g.community_resources "what is available"
end

Factory.define :report do |r|
  r.group_id 1
  r.project_id 1
  r.number_of_youth_reached 10
  r.number_of_adults_reached 10
  r.percent_male 5
  r.percent_female 5
  r.percent_african_american 5
  r.percent_asian 5
  r.percent_caucasian 5
  r.percent_hispanic 5
  r.percent_other 80
  r.money_spent "$100+"
  r.prep_time "1 month +"
  r.other_resources "Lasers"
  r.comment "This was a success! We can blow up planets!"
end