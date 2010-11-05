
# Creates an active group
Factory.define :group do |g|
  g.name "Jedi Knights"
  g.city "Mos Eisley"
  g.organization "Rebel Alliance"
  g.description "An organization of Vader haters."
  g.status "active"
end

# Creates a pending group
Factory.define :pending_group, :class => Group do |g|
  g.name "Han Shot First"
  g.city "Mos Eisley"
  g.organization "Free Greedo"
  g.status "pending"
end