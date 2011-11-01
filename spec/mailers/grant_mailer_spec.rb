require "spec_helper"

describe GrantMailer do
  before do
    @group = Factory.create(:group)
    @user = Factory.create(:user, { role: 'adult sponsor', group: @group })
    @requestor = Factory.create(:user, { email: 'requestor@test.com', role: 'member', group: @group })
  end

  describe "send finalization notice" do
    let(:host) { "http://test.com" }
    let(:project) { Factory.create(:project, { group: @group } )}
    let(:grant) { Factory.create(:grant, { member: @user, status: 'in progress' } ) }
    let(:mail) { GrantMailer.finalization_notification(host, @requestor, @group, project, grant) }

    it "should send to the group sponsor" do
      mail.to.should == [@user.email]
    end

    it "renders the correct subject" do
      mail.subject.should == "You have a new Say What grant application awaiting finalization"
    end
  end
end