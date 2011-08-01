require "spec_helper"

describe UserMailer do
  describe "successful membership request email" do
    let(:user) { Factory.build(:user) }
    let(:group) { Factory.build(:pending_group) }
    let(:mail) { UserMailer.successful_membership_request(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
  end
  
  describe "sponsor pending membership request email" do
    let(:user) { Factory.build(:adult_sponsor) }
    let(:group) { Factory.build(:group) }
    let(:member) { Factory.build(:user) }
    let(:mail) { UserMailer.sponsor_pending_membership_request(user, group, member) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
        
    it "should display the members name in the email" do
      mail.body.encoded.should match(member.name)
    end
    
  end

  describe "send approved notice email" do
    let(:user) { Factory.create(:pending_member) }
    let(:group) { Factory.create(:group) }
    let(:mail) { UserMailer.send_approved_notice(user, group, 'localhost:3000') }
        
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
    it "should display the member's unique setup url" do
      mail.body.encoded.should include_text("http://localhost:3000/setup/member?auth_token=#{user.authentication_token}")
    end

  end
  
  describe "send sponsor promotion notification" do
    let(:user) { Factory.create(:youth_sponsor) }
    let(:group) { Factory.create(:group) }
    let(:mail) { UserMailer.send_sponsor_promotion(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end

    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end  
  end
  
  describe "send sponsor revocation notification" do
    let(:user) { Factory.create(:user, :role => "member", :status => "active") }
    let(:group) { Factory.create(:group) }
    let(:mail) { UserMailer.send_sponsor_revocation(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
  end
  
  describe "send mini-grant approval email" do
    let(:grant) { Factory.create(:minigrant, :status => true) }
    let(:mail) { UserMailer.send_grant_approval(grant) }
    
    it "renders the reciever's email address" do
      mail.to.should == [grant.adult_email]
    end
    
    it "renders the correct subject" do
      mail.subject.should == "SayWhat! Mini-Grant Has Been Approved"
    end
  end
  
  describe "send mini-grant denied email" do
    let(:grant) { Factory.create(:minigrant, :status => false) }
    let(:mail) { UserMailer.send_grant_denied(grant, "reason") }
    
    it "renders the reciever's email address" do
      mail.to.should == [grant.adult_email]
    end
    
    it "renders the correct subject" do
      mail.subject.should == "SayWhat! Mini-Grant Has Been Denied"
    end
  end

end
