class MessagesController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_message, :only => [:show, :destroy]
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - List all of a users messages
  def index
    @messages = @user.messages.desc(:created_at)
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
    message[:message_author] = @user.name
    if @user.admin?
      @sponsors = User.sponsors
      @sponsors.each do |sponsor|
        sponsor.create_message_object(message)
      end
    elsif @user.sponsor?
      @user.group.send_group_message(message)
    end
    redirect_to "/messages"
  end
  
  # GET - Display a message
  def show
    @message.read = true
    @message.save
    respond_with(@message)
  end
  
  # DELETE - Destroy a message
  def destroy
    @message.destroy
    redirect_to "/messages", :notice => "Message has been deleted"
  end
  
  private
    
    def set_user
      @user = current_user
    end
    
    def set_message
      @message = @user.messages.find(params[:id])
    end
   
end
