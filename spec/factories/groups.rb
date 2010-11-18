
# Creates an active group
Factory.define :group do |g|
  g.display_name "Jedi Knights"
  g.city "Mos Eisley"
  g.organization "Rebel Alliance"
  g.description "An organization of Vader haters."
  g.permalink "jedi-knights"
  g.status "active"
end

# Creates a pending group
Factory.define :pending_group, :class => Group do |g|
  g.display_name "Han Shot First"
  g.city "Mos Eisley"
  g.organization "Free Greedo"
  g.status "pending"
end


# Creates an active group
Factory.define :setup_group, :class => Group do |g|
  g.display_name "Jedi Knights"
  g.city "Mos Eisley"
  g.organization "Rebel Alliance"
  g.description "An organization of Vader haters."
  g.status "active"
  g.esc_region "1"
  g.dshs_region "1"
  g.area "central texas"
end