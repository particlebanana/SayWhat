class NotificationsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!

  respond_to :html

  def notifications_index
    @notifications = Notification.find_all(current_user.id)
    Notification.mark_as_read(current_user.id)
    respond_with(@notifications)
  end

  def requests_index
    requests = Request.find_all(current_user.id)
    @group_requests = requests.find_all{|request| request.klass == 'membership'}

    respond_with(@requests)
  end
end