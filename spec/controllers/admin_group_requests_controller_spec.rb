require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGroupRequestsController do
  before(:each) do
    admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
  end

  describe "#index" do
    before do
      Factory.create(:group, {status: "pending"})
      get :index
    end
    
    it "should return an array of Group objects" do
      assigns[:groups].all.count.should == 1
      (assigns[:groups].all.is_a? Array).should be_true
    end
    
    it "should render the index template" do
      response.should render_template('admin_group_requests/index')       
    end
  end
  
  describe "#show" do
    before do
      group = Factory.create(:group, {status: "pending"})
      Factory.create(:user, { email: "show@test.com", group: group, role: 'adult sponsor' })
      get :show, id: group.id
    end
    
    it "should return a Group object as @group" do
      (assigns[:group].is_a? Group).should be_true
    end
    
    it "should render the show template" do
      response.should render_template('admin_group_requests/show')
    end
  end
  
  describe "#update" do
    before do
      @group = Factory.build(:group)
      @sponsor = Factory.create(:user)
      @group.initialize_pending(@sponsor)
      put :update, id: @group.id
    end
    
    it "should set groups status to active" do
      @group.reload.status.should == 'active'
    end
    
    it "should set sponsor's role to adult sponsor" do
      @sponsor.reload.role.should == 'adult sponsor'
    end
    
    it "should redirect to index action" do
      response.should redirect_to('/admin/group_requests')
    end
    
    it "should have a success message" do
      flash[:notice].should =~ /was approved/i
    end
    
    it "should send the sponsor an email" do
      ActionMailer::Base.deliveries.last.subject.should =~ /group has been approved/i
    end
  end
end