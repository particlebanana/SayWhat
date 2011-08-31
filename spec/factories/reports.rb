
# Creates a project report
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