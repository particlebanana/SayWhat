require 'spec_helper'

describe ReportsController do
  before(:each) do
    build_group_with_admin
    build_project
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
    
  end
  
end