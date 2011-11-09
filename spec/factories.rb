FactoryGirl.define do
  factory :user do
    first_name 'Han'
    last_name 'Solo'
    email 'han.solo@gmail.com'
    password 'nerfherder' 
    password_confirmation 'nerfherder'
  end

  factory :group do
    display_name "Jedi Knights"
    city "Mos Eisley"
    organization "Rebel Alliance"
    description "An organization of Vader haters."
    permalink "jedi-knights"
    status "active"
    esc_region "1"
    dshs_region "1"
    area "central texas"
  end

  factory :project do
    display_name "Build Death Star"
    location "Outer Space"
    start_date "11/11/2011"
    end_date "11/22/2011"
    focus "Secondhand Smoke Exposure"
    audience "Elementary Students"
    description "A Top Secret project"
  end

  factory :message do
    message_type "message"
    author "Han Solo"
    subject "Generic Message"
    content "This is a generic message"
  end

  factory :grant do
    project @project
    check_payable "Group 1"
    mailing_address "123 Fake St"
    phone "123-456-7890"
    planning_team "Billy Bob, Suzy Jo"
    serviced "Some peeps"
    goals "Be successful"
    funds_use "Buy drugs"
    partnerships "Some peeps"
    resources "Shovels"
  end

  factory :report do
    group @group
    project @project
    number_of_youth_reached 10
    number_of_adults_reached 10
    percent_male 5
    percent_female 5
    percent_african_american 5
    percent_asian 5
    percent_caucasian 5
    percent_hispanic 5
    percent_other 80
    money_spent "$100+"
    prep_time "1 month +"
    other_resources "Lasers"
    comment "This was a success! We can blow up planets!"
  end
end