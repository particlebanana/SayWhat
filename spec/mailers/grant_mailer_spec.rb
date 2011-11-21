require "spec_helper"

describe GrantMailer do
  before do
    @group = FactoryGirl.create(:group)
    @user = FactoryGirl.create(:user, { role: 'adult sponsor', group: @group })
    @admin = FactoryGirl.create(:user, { email: 'admin@test.com', role: 'admin' } )
    @requestor = FactoryGirl.create(:user, { email: 'requestor@test.com', role: 'member', group: @group })
  end

  describe "send finalization notice" do
    let(:host) { "http://test.com" }
    let(:project) { FactoryGirl.create(:project, { group: @group } )}
    let(:grant) { FactoryGirl.create(:grant, { project: project, member: @user, status: 'in progress' } ) }
    let(:mail) { GrantMailer.finalization_notification(host, @requestor, @group, project, grant) }

    it "should send to the group sponsor" do
      mail.to.should == [@user.email]
    end

    it "renders the correct subject" do
      mail.subject.should == "You have a new Say What grant application awaiting finalization"
    end
  end

  describe "notify_admin" do
    let(:project) { FactoryGirl.create(:project, { group: @group } )}
    let(:grant) { FactoryGirl.create(:grant, { project: project, member: @user, status: 'completed' } ) }
    let(:mail) { GrantMailer.notify_admin(@admin.email, grant) }

    it "should send to the site admin" do
      mail.to.should == [@admin.email]
    end

    it "renders the correct subject" do
      mail.subject.should == "You have a new SayWhat mini-grant awaiting approval"
    end
  end

  describe "send grant approval email" do
    let(:project) { FactoryGirl.create(:project, { group: @group } )}
    let(:grant) { FactoryGirl.create(:grant, { project: project, member: @user, status: 'approved' } ) }
    let(:mail) { GrantMailer.grant_approved(grant) }

    it "should send to the group sponsor" do
      mail.to.should == [@user.email]
    end

    it "renders the correct subject" do
      mail.subject.should == "Your Say What! Project Grant Has Been Approved"
    end
  end

  describe "send grant denied email" do
    let(:project) { FactoryGirl.create(:project, { group: @group } )}
    let(:grant) { FactoryGirl.create(:grant, { project: project, member: @user, status: 'approved' } ) }
    let(:mail) { GrantMailer.grant_denied(grant, "reason") }

    it "should send to the group sponsor" do
      mail.to.should == [@user.email]
    end

    it "renders the correct subject" do
      mail.subject.should == "Your Say What! Project Grant Has Been Denied"
    end
  end
end