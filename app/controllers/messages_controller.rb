class MessagesController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_message, :only => [:show, :destroy]
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - List all of a users messages
  def index
    @messages = @user.messages
    respond_with(@messages)
  end
  
  # GET - Create a new message
  def new
    @message = Message.new
    respond_with(@message)
  end
  
  # POST - Create a new message and send it to all members
  def create
    message = params[:message]
    message[:message_type] = "message"
    message[:author] = @user.name
    if @user.admin?
      @sponsors = User.sponsors
      @sponsors.each do |sponsor|
        message = sponsor.create_message_object(message)
        UserMailer.send_message_notification(sponsor, @user.name, message.message_content).deliver
      end
    elsif @user.sponsor?
      @user.group.send_group_message(message, @user.name)
    end
    redirect_to "/messages"
  end
  
  # GET - Display a message
  def show
    if @message
      @message.read = true
      @message.save!
      respond_with(@message)
    else
      redirect_to "/messages", :notice => "Could not find that message."
    end
  end
  
  # DELETE - Destroy a message
  def destroy
    if @message.destroy
      redirect_to "/messages", :notice => "Message has been deleted"
    else
      redirect_to "/messages", :error => "Message could not deleted"
    end
  end
  
  private
    
    def set_user
      @user = current_user
    end
    
    def set_message
      @message = Message.find(params[:id])
    end
   
end
