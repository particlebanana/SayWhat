require 'spec_helper'

describe AdminGrantsController do
  before(:each) do
    admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
    group = Factory.create(:group)
    user = Factory.create(:user, { group: group, role: 'adult sponsor' })
    project = Factory.create(:project, { group: group })
    @grant = Factory.create(:grant, { member: user, project: project, status: 'approved' })
  end
    
  describe "#index" do
    before { get :index }
    
    it "should return an array of Grant objects" do
      assigns[:grants].count.should == 1
    end
    
    it "should render the index template" do
      response.should render_template('admin_grants/index')      
    end
  end
  
  describe "#show" do
    before { get :show, id: @grant.id }
    
    it "should return a Grant object" do
      (assigns[:grant].is_a? Grant).should be_true
    end
    
    it "should render the show template" do
      response.should render_template('admin_grants/show')
    end
  end
  
  describe "#destroy" do
    context "given a reason" do
      before { post :destroy, {id: @grant.id, reason: "curriculum"} }
      
      it "should remove the grant from the database" do
        Grant.where(id: @grant.id).first.should == nil
      end
      
      it "should have a success message" do
        flash[:notice].should =~ /application has been removed/i
      end
      
      it "should send the group sponsor an email" do
        ActionMailer::Base.deliveries.last.subject.should =~ /grant has been denied/i
        ActionMailer::Base.deliveries.last.to.first.should == @grant.project.group.adult_sponsor.email
      end
    end
    
    context "without reason" do
      before { post :destroy, {id: @grant.id } }
      
      it "should redirect to requests" do
        response.should redirect_to("/admin/grants/#{@grant.id}/edit")
      end
      
      it "should have an error message" do
        flash[:alert].should =~ /error denying grant/i
      end
    end
  end
end