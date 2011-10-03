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
    if current_user
      @timeline = Hashie::Mash.new($feed.timeline("user:#{current_user.id}"))
      render "timeline"
    else
      render "home"
    end
  end

  # GET - History
  def history
  end

  # GET - Leon
  def leon
  end

  # GET - Join Page
  def join
  end
end