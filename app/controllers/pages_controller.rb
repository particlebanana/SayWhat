class PagesController < ApplicationController
  layout "application"  
  respond_to :html
  
  # GET - Home Page
  def home
    @projects = ProjectCache.desc(:end_date).find_all{ |project| project.end_date < Date.today}
  end
  
  # GET - Join Page
  def join
  end

end