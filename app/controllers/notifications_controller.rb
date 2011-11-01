class NotificationsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!, except: [:overview, :index, :show]

  respond_to :html

  def index
    @notifications = Notification.find(current_user.id)
    Notification.mark_as_read(current_user.id)
    respond_with(@notifications)
  end
end