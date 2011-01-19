require 'spec_helper'

describe ReportsController do
  before(:each) do
    build_group_with_admin
    build_project
    set_project_dates_for_reports
    sign_in @admin
  end
  
  describe "#new" do
    
    it "should assign @project to a new project instance" do
      get :new, :permalink => @group.permalink, :name => @project.name
      assigns[:report].should_not == nil
    end
    
    it "should render the reporting form" do
      get :new, :permalink => @group.permalink, :name => @project.name
      response.should render_template("reports/new")
    end
    
    it "should not allow reports on upcoming projects" do
      @project.end_date = Date.today + 1.day
      @project.save
      get :new, :permalink => @group.permalink, :name => @project.name
      response.should be_redirect
      response.should redirect_to("/groups/#{@group.permalink}/projects/#{@project.name}")
    end
    
  end

  describe "#create" do
    
    it "should create a project report" do
      report = build_report_params
      post :create, report
      response.should be_redirect
      @group.reload.projects.first.report.should_not == nil
    end
    
    it "should re-display form when an incomplete form is submitted" do
      report = build_report_params
      report[:report][:number_of_youth_reached] = ''
      post :create, report
      response.should render_template("reports/new")
    end
    
    it "should allow a group's youth sponsor to report" do
      @user.role = "youth sponsor"
      @user.save
      sign_in @user
      report = build_report_params
      post :create, report
      response.should be_redirect
      @group.reload.projects.first.report.should_not == nil
    end
    
    it "should only allow a group's sponsors to create a report" do
      @another_user = seed_additional_group
      sign_in @another_user
      report = build_report_params
      report[:report][:number_of_youth_reached] = ''
      post :create, report
      response.should redirect_to("/")
    end
    
    it "should not allow reports on upcoming projects" do
      @project.end_date = Date.today + 1.day
      @project.save
      report = build_report_params
      post :create, report
      response.should be_redirect
      response.should redirect_to("/groups/#{@group.permalink}/projects/#{@project.name}")
    end
    
    it "should update the group tally for adults reached" do
      @group.adults_reached_tally.should == 0
      report = build_report_params
      post :create, report
      @group.reload.adults_reached_tally.should == 10
    end
    
    it "should update the group tally for youth reached" do
      @group.youth_reached_tally.should == 0
      report = build_report_params
      post :create, report
      @group.reload.youth_reached_tally.should == 10
    end
    
  end
  
end