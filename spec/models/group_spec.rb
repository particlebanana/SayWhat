require 'spec_helper'

describe Group do
  before { @group = Factory.create(:group) }
  
  context "Factory" do
    subject { @group }
    it { should have_many(:users) }
    it { should have_many(:projects) }
    
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:esc_region) }
    it { should validate_presence_of(:dshs_region) }
    it { should validate_presence_of(:area) }
  
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:permalink) }
  
    it { should validate_length_of(:permalink).within(4..20) }
    
    it "should downcase name field" do
      @group.name.should == @group.display_name.downcase
    end
  end
  
  describe "#adult_sponsor" do
    before do
      Factory.create(:user, {role: "adult sponsor", group: @group})
      @user = @group.adult_sponsor
    end
    
    it "should return a user object" do
      @user.is_a?(User).should be_true
    end
  end
  
  describe "#make_slug" do
    it "should escape special characters" do
      @group.permalink = "It's A Trap!?!?!"
      @group.make_slug
      @group.permalink.should == "its-a-trap"    
    end
  end
=begin  
  describe ".reassign_sponsor" do
    before(:each) do
      @user = build_decaying_group
      @group.reassign_sponsor(@user.id)
    end
          
    context "user" do
      subject{ @user.reload }
      its(:role) { should == "adult sponsor" }
    end
    
    context "admin" do  
      subject{ @captain_zissou.reload }
      its(:role) { should == "member" }
    end
  end
=end
end
