class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :group_id, type: Integer
  field :project_id, type: Integer
  field :number_of_youth_reached, type: Integer
  field :number_of_adults_reached, type: Integer
  field :percent_male, type: Integer
  field :percent_female, type: Integer
  field :percent_african_american, type: Integer
  field :percent_asian, type: Integer
  field :percent_caucasian, type: Integer
  field :percent_hispanic, type: Integer
  field :percent_other, type: Integer
  field :money_spent
  field :prep_time
  field :other_resources
  field :comment
  field :level_of_impact
  
  attr_protected :level_of_impact

  validates_presence_of [:group_id, :project_id, :number_of_youth_reached, :number_of_adults_reached, :percent_male, :percent_female, :percent_african_american, :percent_asian, :percent_caucasian, :percent_hispanic, :percent_other, :money_spent, :prep_time]
  
  after_create :update_counter
      
  def filters
    money = ['', '$0-$25', '$25-$50', '$50-$100', '$100+']
    prep = ['', '1 day or less', '2 days - 1 week', '2-3 weeks', '1 month+']
    filters = {
      money: money.map { |money| [money, money] },
      prep: prep.map { |prep| [prep, prep] }
    }
  end
  
  private

  def update_counter
    counter = Counter.where(group_id: self.group_id).first
    if counter
      counter.update_totals({youth_total: self.number_of_youth_reached, adult_total: self.number_of_adults_reached})
    else
      counter = Counter.new({youth_total: self.number_of_youth_reached, adult_total: self.number_of_adults_reached})
      counter.group_id = self.group_id
      counter.save
    end
  end
    
end
