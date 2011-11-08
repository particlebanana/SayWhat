require 'spec_helper'

describe ReportsController do
  before(:each) do
    @group = FactoryGirl.create(:group)
    @user = FactoryGirl.create(:user, { role: 'adult sponsor', group: @group })
    @project = FactoryGirl.create(:project, { group: @group })
    sign_in @user
  end
  
  describe "#new" do
    before { get :new, :group_id => @group.permalink, :project_id => @project.id }
    
    it "should create a new Report instance" do
      assigns[:report].is_a?(Report).should be_true
    end
    
    it "should render the reporting form" do
      response.should render_template("reports/new")
    end
  end

  describe "#create" do
    before do
      @report = FactoryGirl.build(:report, { project: @project, group: @group })
      post :create, {:report => @report.attributes, :group_id => @group.permalink, :project_id => @project.id}
    end
    
    it "should create a project report" do
      Report.where(project_id: @project.id).count.should == 1
    end

    it "should redirect to project page" do
      response.should redirect_to(group_project_path(@group.permalink, @project))
    end
  end
end