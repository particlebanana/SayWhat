
# Creates a Full Group
Factory.define :group do |g|
  g.name "Han Shot First"
  g.city "Mos Eisley"
  g.organization "Free Greedo"
  g.description "An organization to set the truth right about Greedo's involvement in the Mos Eisley shooting"
  g.status "active"
end

# Creates a pending group
Factory.define :pending_group, :class => Group do |g|
  g.name "Billy Bob's Kids"
  g.city "Backwoods"
  g.organization "Redneck Middle School"
  g.status "pending"
end