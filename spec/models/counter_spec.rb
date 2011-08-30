require 'spec_helper'

describe Counter do
  
  it { should validate_presence_of(:group_id) }
  
  describe "creating a counter" do
    before do
      @counter = Counter.new
      @counter.group_id = 1
      @counter.save
    end
    
    it "should set default on totals" do
      @counter.youth_total.should == 0
      @counter.adult_total.should == 0
    end
  end
  
  describe "incrementing counter totals" do
    before do
      @counter = Counter.new
      @counter.group_id = 1
      @counter.save
    end
    
    it "should increase youth total" do
      @counter.update_totals({youth_total: 2})
      @counter.reload.youth_total.should == 2
    end
    
    it "should increase adult total" do
      @counter.update_totals({adult_total: 2})
      @counter.reload.adult_total.should == 2
    end
    
    it "should decrease if value is negative" do
      @counter.update_totals({adult_total: -2})
      @counter.reload.adult_total.should == -2
    end
  end
  
end