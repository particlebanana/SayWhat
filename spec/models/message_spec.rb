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
end