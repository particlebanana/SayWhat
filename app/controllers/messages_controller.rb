class MessagesController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_user
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - List all of a users messages
  def index
    @messages = @user.messages
    respond_with(@messages)
  end
  
  # POST - Create a new message and send it to all members
  def create
    message = params[:message]
    message['message_type'] = "message"
    @user.group.send_group_message(message)
    redirect_to "/messages"
  end
  
  private
    
    def set_user
      @user = current_user
    end
  
  
end
