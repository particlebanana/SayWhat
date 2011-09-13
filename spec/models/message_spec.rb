require 'spec_helper'

describe Message do
  context "Factory" do
    before { @message = Factory.create(:message) }
    
    subject { @message }
    it { should belong_to(:user) }
    
    it { should validate_presence_of(:message_type) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:content) }
  end
  
  describe "payload" do
    before { @message = Factory.create(:message) }
    
    it "should allow meta data to be attached" do
      @message.payload = 1
      @message.valid? should be_true
    end
  end
  
  describe "#alert_admins" do
    before do
      @admin = Factory.create(:user, { email: 'alert@gmail.com', role: 'admin' } )
      group = Factory.create(:group)
      user = Factory.create(:user, { group: group } )
      Message.alert_admins( { group: group, user: user } )
    end
    
    it "should send the admins an email alert" do
      ActionMailer::Base.deliveries.last.to.should == [@admin.email]
    end
  end
  
  describe "#create_group_request" do
    before do
      @group = Factory.create(:group)
      @user = Factory.create(:user)
      @sponsor = Factory.create(:user, { email: 'admin@gmail.com', group: @group, role: 'adult sponsor' } )
      @response = Message.create_group_request(@group, @user, @sponsor)
    end      
    
    it "should return a message object" do
      @response.is_a? Message
    end
    
    it "should send the requesting user an email" do
      ActionMailer::Base.deliveries.select { |e| e[:to].to_s == @user.email && e[:subject].to_s =~ /awaiting approval/i }.count.should > 0
    end
    
    it "should send the site admins an email" do
      ActionMailer::Base.deliveries.select { |e| e[:to].to_s == @sponsor.email && e[:subject].to_s =~ /pending membership request/i }.count.should > 0
    end
    
    subject { @response }
    it { is_a? Message }
    it { should be_valid }
    its([:message_type]) { should == 'request' }
  end
end