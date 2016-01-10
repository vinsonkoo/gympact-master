class MessagesController < ApplicationController
  
  def index
    @messages = Message.all
    @users = User.all
    @weeks = Week.all
  end

  def show
    @message = Message.find(params[:id])
    @pact = Pact.find_by(id: @message.pact_id)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)  
    if @message.save
      # handle successful save
      redirect_to root_url, notice: "Message created."
    else
      render 'new'
    end
  end

  def update
    @message = Message.find(params[:id])
    if @message.is_workout == true
      @message.is_workout = false
    else
      @message.is_workout = true
    end
    @message.update(message_params)
    redirect_to pact_path(@message.pact_id)
  end



  # def is_workout?(message)
  #   @message = Message.find(params[:id])
  #   if @message.is_workout.true?
  #     @mesage.is_workout = false
  #     @message.save
  #   else
  #     @message.is_workout = true
  #     @message.save
  #   end
  #   redirect_to pact_path(@message.pact_id)
  # end

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
    params.require(:message).permit(:pact_id, :user_id, :message, :date_sent, :photo_url, :media, :image, :video, :date, :time, :msg_date_time, :sender, :user, :week_id)
  end


end
