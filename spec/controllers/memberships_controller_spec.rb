require 'spec_helper'

describe MembershipsController do
  before do
    @group = FactoryGirl.create(:group)
    @pending_member = FactoryGirl.create(:user, { email: "pending@gmail.com", group: @group, status: "pending", role: "pending" } )
  end
  
  describe "#create" do
    before do
      FactoryGirl.create(:user, { group: @group, email: "sponsor@gmail.com", role: "adult sponsor" } )
      sign_in FactoryGirl.create(:user, { role: "member" } )
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
      user = FactoryGirl.create(:user, { group: @group, role: "adult sponsor" } )
      @membership = Membership.new( { user: user, group: @group } )
      @membership.create_request
      sign_in user
    end
  
    describe "#update" do
      before { put :update, { group_id: @group.permalink, user_id: @pending_member.id, id: @membership.id } }
    
      subject { @pending_member.reload }
      its([:group_id]) { should == @group.id }
    
      it "should set a notice message" do
        flash[:notice].should =~ /request has been accepted/i
      end
    
      it "should redirect to group page" do
        response.should redirect_to("/groups/#{@group.permalink}")
      end
    end
  
    describe "#destroy" do
      before do
        delete :destroy, { group_id: @group.permalink, user_id: @pending_member.id, id: @membership.id }
      end
    
      it "should set a notice message" do
        flash[:notice].should =~ /has been denied/i
      end
    
      it "should redirect to group page" do
        response.should redirect_to("/groups/#{@group.permalink}")
      end
    end
  end
 
  # Check permissions on actions - Should not allow group member to manage memberships.
  context "group member" do
    before do
      user = FactoryGirl.create(:user, { group: @group, role: "member" } )
      @membership = Membership.create( { user: user, group: @group } )
      sign_in user
    end
    
    describe "#update" do
      before { put :update, { group_id: @group.permalink, user_id: @pending_member.id, id: @membership.id } }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    describe "#destroy" do
      before { delete :destroy, { group_id: @group.permalink, user_id: @pending_member.id, id: @membership.id } }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
end