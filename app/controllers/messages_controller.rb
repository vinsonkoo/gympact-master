class MessagesController < ApplicationController
  
  def index
    @messages = Message.all
    @users = User.all
    @weeks = Week.all
  end

  def show
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)  
    if @message.save
      # handle successful save
      redirect_to root_url, notice: "Saved"
    else
      render 'new'
    end
  end

  def import
    # begin
    #   Message.import( params[:message][:import_file])
    #   flash[:notice] = "Import successful"
    #   redirect_to messages_path
    # rescue => exception
    #   flash[:notice] = "There was a problem importing. #{exception.message}"
    #   redirect_to import_new_messages_path
    # end
    uploaded_file = Message.import(params[:file])
    redirect_to messages_path, notice: 'Chat imported.'
  end

  private
  
  def message_params
    params.require(:message).permit(:message, :pact_id, :user_id, :date_sent, :photo_url, :media, :image, :video, :date, :time, :msg_date_time, :sender, :user, :week_number)
  end


end
