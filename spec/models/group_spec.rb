require 'spec_helper'

describe Group do
  before { @group = FactoryGirl.create(:group) }
  
  context "Factory" do
    subject { @group }
    it { should have_many(:users) }
    it { should have_many(:projects) }
    it { should have_many(:memberships) }
    
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

    it "should generate an object key" do
      res = JSON.parse($feed.retrieve("group:#{@group.id}").body)
      res['name'].should == @group.display_name
    end

    it "should regenerate an object key on update" do
      @group.save
      res = JSON.parse($feed.retrieve("group:#{@group.id}").body)
      res['photo'].should == @group.profile_photo_url(:thumb)
    end
  end
  
  describe "#adult_sponsor" do
    before do
      FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      @user = @group.adult_sponsor
    end
    
    it "should return a user object" do
      @user.is_a?(User).should be_true
    end
  end
    
  describe "#initialize_pending" do
    before do
      @requesting_user = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:user, { email: 'admin@gmail.com', role: 'admin' } )
      @group.permalink = "It's A Trap!?!?!"
      @response = @group.initialize_pending(@requesting_user)
    end
    
    describe "#setup_group" do
      subject { @group.reload }
      its([:status]) { should == 'pending' }
      its([:permalink]) { should == 'its-a-trap'}
    end
    
    describe "#send_notifications" do
      it "should send the requesting user an email" do
        ActionMailer::Base.deliveries.select { |e| e[:to].to_s == @requesting_user.email && e[:subject].to_s =~ /awaiting approval/i }.count.should > 0
      end
      
      it "should send the site admins an email" do
        ActionMailer::Base.deliveries.select { |e| e[:to].to_s == @admin.email && e[:subject].to_s =~ /you have a pending group request/i }.count.should > 0
      end
    end
    
    it "should return true" do 
      @response.should == true
    end
    
    subject { @requesting_user.reload }
    its([:group_id]) { should == @group.id }
  end
  
  describe "#approve" do
    before do
      @user = FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      @response = @group.approve("http://test.com")
    end

    subject { @response }
    it { should be_true }

    it "should set the group status to active" do
      @group.reload.status.should == 'active'
    end

    it "should send the sponsor an email" do
      ActionMailer::Base.deliveries.last.subject.should =~ /group has been approved/i
    end

    it "should write an event to the user's timeline" do
      res = $feed.timeline("user:#{@user.id}")
      res[:feed].first[:data][:message].should == "#{@user.name} created the group #{@group.display_name}"
    end
  end

  describe "#deny" do
    before do
      FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
      @reason = reasons.first
    end
    
    context "success" do
      before { @response = @group.deny(@reason) }
      
      subject { @response }
      it { should be_true }
      
      it "should destroy self" do
        Group.where(id: @group.id).count.should == 0
      end
    
      it "should remove group_id from sponsor account" do
        User.where(group_id: @group.id).count.should == 0
      end
    
      it "should send the sponsor an email" do
        ActionMailer::Base.deliveries.last.subject.should =~ /group has been denied/i
      end
    end
    
    context "invalid" do
      before { @response = @group.deny('') }
      
      subject { @response }
      it { should be_false }
    end
  end
  
  describe "#reassign_sponsor" do
    before do
      @sponsor = FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      @member = FactoryGirl.create(:user, {email: "member@test.com", group: @group})
      @group.reassign_sponsor(@member.id)
    end
    
    context "@sponsor" do
      subject{ @sponsor.reload }
      its(:role) { should == "member" }
    end
    
    context "@member" do  
      subject{ @member.reload }
      its(:role) { should == "adult sponsor" }
    end
  end
end