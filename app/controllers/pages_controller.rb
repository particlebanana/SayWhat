class PagesController < ApplicationController
  layout "application"  
  
  before_filter :authenticate_user!, :only => :index
  
  respond_to :html
  
  # GET - Admin Dashboard
  def index 
    @counts = {
      group: {pending: Group.pending.count, active: Group.active.count},
      grant: {pending: Grant.pending.count, approved: Grant.approved.count},
      projects: Project.count
    }
    render :layout => "admin"
  end
  
  # GET - Home Page
  def home
    @projects = Project.order('end_date ASC').find_all{ |project| project.end_date < Date.today}
  end
  
  # GET - Join Page
  def join
  end

end