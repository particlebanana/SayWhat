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
  
end
