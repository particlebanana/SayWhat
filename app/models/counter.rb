class Counter
  include Mongoid::Document
  
  field :group_id, type: Integer  
  field :youth_total, type: Integer, default: 0
  field :adult_total, type: Integer, default: 0
  
  attr_protected :group_id
  
  validates_presence_of :group_id
  
  def update_totals(attributes)
    self.youth_total += attributes[:youth_total] if attributes[:youth_total]
    self.adult_total += attributes[:adult_total] if attributes[:adult_total]
    self.save!
  end
  
end
