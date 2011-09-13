require 'spec_helper'

describe MembershipsController do
  before do
    @group = Factory.create(:group)
    @pending_member = Factory.create(:user, { email: "pending@gmail.com", group: @group, status: "pending", role: "pending" } )
  end
  
  describe "#create" do
    before do
      Factory.create(:user, { group: @group, email: "sponsor@gmail.com", role: "adult sponsor" } )
      sign_in Factory.create(:user, { role: "member" } )
      post :create, { group_id: @group.permalink, user_id: @pending_member.id }
    end
    
    it "should redirect to group page" do
      response.should redirect_to("/groups/#{@group.permalink}")
    end
    
    it "should include a flash notice" do
      flash[:notice].should =~ /request has been submitted/i
    end
  end
   
  context "adult sponsor" do
    before do
      user = Factory.create(:user, { group: @group, role: "adult sponsor" } )
      @message = Factory.create(:message, { user: user } )
      sign_in user
    end
  
    describe "#update" do
      before { put :update, { group_id: @group.permalink, user_id: @pending_member.id, message: @message.id } }
    
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
      before { delete :destroy, { group_id: @group.permalink, user_id: @pending_member.id, message: @message.id } }
        
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
      user = Factory.create(:user, { group: @group, role: "member" } )
      @message = Factory.create(:message, { user: user } )
      sign_in user
    end
    
    describe "#update" do
      before { put :update, { group_id: @group.permalink, user_id: @pending_member.id, message: @message.id } }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    describe "#destroy" do
      before { delete :destroy, { group_id: @group.permalink, user_id: @pending_member.id, message: @message.id } }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
end