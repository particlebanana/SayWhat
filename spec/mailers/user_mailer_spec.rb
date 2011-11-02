require "spec_helper"

describe UserMailer do
  before { @user = Factory.build(:user) }

  describe "successful membership request email" do
    let(:user) { @user }
    let(:group) { Factory.build(:group) }
    let(:mail) { UserMailer.successful_membership_request(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
  end
  
  describe "sponsor pending membership request email" do
    let(:user) { Factory.build(:user, { role: 'adult sponsor' } ) }
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
    let(:user) { @user }
    let(:group) { Factory.create(:group) }
    let(:mail) { UserMailer.send_approved_notice(user, group, 'localhost:3000') }
        
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
    
    it "should display the group's name in the email" do
      mail.body.encoded.should match(group.display_name)
    end
    
    it "should display the member's group url" do
      mail.body.encoded.should include_text("http://localhost:3000/groups/#{group.permalink}")
    end

  end
  
  describe "send sponsor promotion notification" do
    let(:user) { Factory.create(:user, { role: 'youth sponsor' } ) }
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
    let(:user) { Factory.create(:user, { role: "member", status: "active" } ) }
    let(:group) { Factory.create(:group) }
    let(:mail) { UserMailer.send_sponsor_revocation(user, group) }
    
    it "renders the reciever's email address" do
      mail.to.should == [user.email]
    end
  end
end