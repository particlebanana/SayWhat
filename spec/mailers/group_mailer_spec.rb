require "spec_helper"

describe GroupMailer do
  
  describe "successful group request" do
    let(:user) { FactoryGirl.build(:user) }
    let(:group) { FactoryGirl.build(:group) }
    let(:mail) { GroupMailer.successful_group_request(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
  end
  
  describe "admin pending group notification" do
    let(:user) { FactoryGirl.build(:user, { role: 'admin' } ) }
    let(:group) { FactoryGirl.build(:group) }
    let(:sponsor) { FactoryGirl.build(:user, { group: group } ) }
    let(:mail) { GroupMailer.admin_pending_group_request(user, group, sponsor) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
    it "should display the sponsor's name in the email" do
      mail.body.encoded.should match(sponsor.last_name)
    end
    
  end
  
  describe "approved group notification" do
    let(:user) { FactoryGirl.build(:user) }
    let(:group) { FactoryGirl.create(:group) }
    let(:mail) { GroupMailer.send_approved_notice(user, group, 'localhost:3000') }
        
    it "renders the reciever's email address" do
      user.role = "adult sponsor"
      user.status = "setup"
      user.save
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      user.role = "adult sponsor"
      user.status = "setup"
      user.save
      mail.body.encoded.should match(group.display_name)
    end
    
    it "should have a descriptive subject line" do
      user.role = "pending"
      user.status = "pending"
      user.save
      mail.subject.should == "Your group has been approved on SayWhat!"
    end
  end
  
  describe "denied group notification" do
    let(:user) { FactoryGirl.build(:user) }
    let(:group) { FactoryGirl.create(:group) }
    let(:reason) { "This is a test reason" }
    let(:mail) { GroupMailer.send_denied_notice(user, group, reason) }
    
    it "renders the reciever's email address" do
      user.role = "pending"
      user.status = "pending"
      user.save
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      user.role = "pending"
      user.status = "pending"
      user.save
      mail.body.encoded.should match(group.display_name)
    end
    
    it "should have a descriptive subject line" do
      user.role = "pending"
      user.status = "pending"
      user.save
      mail.subject.should == "Your group has been denied on SayWhat!"
    end
    
    it "should include the denied reason" do
      user.role = "pending"
      user.status = "pending"
      user.save
      mail.body.encoded.should match("This is a test reason")
    end
  end
  
  describe "group invite notification" do
    let(:user) { FactoryGirl.build(:user) }
    let(:group) { FactoryGirl.create(:group) }
    let(:mail) { GroupMailer.send_invite(user, group, "localhost:3000") }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
  end
  
end
