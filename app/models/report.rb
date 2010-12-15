class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  field :number_of_youth_reached, :type => Integer
  field :number_of_adults_reached, :type => Integer
  field :percent_male, :type => Integer
  field :percent_female, :type => Integer
  field :percent_african_american, :type => Integer
  field :percent_asian, :type => Integer
  field :percent_caucasian, :type => Integer
  field :percent_hispanic, :type => Integer
  field :percent_other, :type => Integer
  field :money_spent
  field :prep_time
  field :other_resources
  field :comment
  field :level_of_impact
  embedded_in :project, :inverse_of => :report
  
  attr_protected :level_of_impact

  validates_presence_of [:number_of_youth_reached, :number_of_adults_reached, :percent_male, :percent_female, :percent_african_american, :percent_asian, :percent_caucasian, :percent_hispanic, :percent_other, :money_spent, :prep_time]

end
