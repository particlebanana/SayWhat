require "spec_helper"

describe GroupMailer do
  
  describe "successful group request" do
    let(:user) { Factory.build(:user_input) }
    let(:group) { Factory.build(:pending_group) }
    let(:mail) { GroupMailer.successful_group_request(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
  end
  
  describe "admin pending group notification" do
    let(:user) { Factory.build(:admin) }
    let(:group) { Factory.build(:pending_group) }
    let(:sponsor) { Factory.build(:user_input) }
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
    let(:user) { Factory.build(:user_input) }
    let(:group) { Factory.create(:setup_group) }
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
    
    it "should display the group's unique setup url" do
      user.role = "adult sponsor"
      user.status = "setup"
      user.save
      mail.body.encoded.should include_text("http://localhost:3000/setup?auth_token=#{user.authentication_token}")
    end

  end
  
  describe "setup completed notification" do
    let(:user) { Factory.create(:user, :role => "adult sponsor", :status => "active") }
    let(:group) { Factory.create(:group) }
    let(:mail) { GroupMailer.send_completed_setup_notice(user, group, 'localhost:3000') }
        
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
    it "should display the group's permalink" do
      mail.body.encoded.should include_text("http://localhost:3000/#{group.permalink}")
    end
  end
  
  describe "group invite notification" do
    let(:user) { Factory.build(:user_input) }
    let(:group) { Factory.create(:group) }
    let(:mail) { GroupMailer.send_invite(user, group, "localhost:3000") }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
  end
  
end
