require 'spec_helper'

describe MembershipsController do
  before do
    @group = Factory.create(:group)
    @pending_member = Factory.create(:user, {email: "pending@gmail.com", group: @group, status: "pending", role: "pending"})
  end
  
  context "adult sponsor" do
    before do
      user = Factory.create(:user, {group: @group, role: "adult sponsor"})
      @message = Factory.create(:message, {user: user})
      sign_in user
    end
  
    describe "#update" do
      before { put :update, {permalink: @group.permalink, user_id: @pending_member.id, message: @message.id}}
    
      subject { @pending_member.reload }
      its([:status]) { should == "active" }
      its([:role]) { should == "member" }
    
      it "should send pending member an email" do
        ActionMailer::Base.deliveries.last.to.should == [@pending_member.email]
      end
    
      it "should set a notice message" do
        flash[:notice].should =~ /has been added to group/i
      end
    
      it "should redirect to /messages" do
        response.should redirect_to('/messages')
      end
    end
  
    describe "#destroy" do
      before { delete :destroy, {permalink: @group.permalink, user_id: @pending_member.id, message: @message.id}}
        
      it "should remove the pending member" do
        User.where(id: @pending_member.id).count.should == 0
      end
    
      it "should set a notice message" do
        flash[:notice].should =~ /has been removed/i
      end
    
      it "should redirect to /messages" do
        response.should redirect_to('/messages')
      end
    end
  end
  
  # Check permissions on actions - Should not allow group member to manage memberships.
  context "group member" do
    before do
      user = Factory.create(:user, {group: @group, role: "member"})
      @message = Factory.create(:message, {user: user})
      sign_in user
    end
    
    describe "#update" do
      before { put :update, {permalink: @group.permalink, user_id: @pending_member.id, message: @message.id} }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    describe "#destroy" do
      before { delete :destroy, {permalink: @group.permalink, user_id: @pending_member.id, message: @message.id} }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
end