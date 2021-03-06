class PactsController < ApplicationController
  
  def new
    @pact = Pact.new
  end

  def create
    @pact = Pact.new(pact_params)
    if @pact.save
      # redirect_to @pact
      redirect_to add_users_path(@pact)
    else
      render 'new'
    end

  end
  
  def edit
    @pact = Pact.find(params[:id])
  end

  def destroy
    @pact = Pact.find(params[:id])
    @pact.destroy
    respond_to do |format|
      format.html { redirect_to pact_url }
      format.json { head :no_content }
    end
  end

  def update
    @pact = Pact.find(params[:id])
    # debugger
    if params[:pact].has_key?(:pact_photos)
      if params[:pact].has_key?(:pact_photos)

        params[:pact][:pact_photos].each do |a|
          @pact_photo = @pact.pact_photos.create!(:photo => a)
          # debugger
          # @pact_photo.photo = a.original_filename
          @pact_photo.save
        end
        redirect_to @pact
      end

    else

      @pact.update(pact_params)
      # debugger

      if @pact.users.exists?

        if @pact.goals.exists?

          if @pact.penalties.exists?
            # after adding users, goals, and penalties, redirect to pact
            redirect_to @pact

          else
            #after adding goals, user will be redirected to add penalties
            redirect_to add_penalties_path(@pact)

          end

        else
          # after adding users, user will be redirected to add goals
          redirect_to add_goals_path(@pact)

        end

      else
        # after creating the pact, user will be redirected to add users
        redirect_to add_users_path(@pact)

      end

    end # if params[:pact].has_key?(:pact_photos)

  end

  def all 
    @pact = Pact.all
  end

  def index
    @pact = Pact.all
    @attachments = @pact.attachments
  end

  def show
    @pact = Pact.find(params[:id])
    @weeks = @pact.weeks
    @users = @pact.users
    @goals = @pact.goals
    @penalties = @pact.penalties
    @workouts = @pact.workouts
    @payments = @pact.payments
    # @pact_attachment = @pact.pact_attachments.build
  end

  def users
    @pact = Pact.find(params[:pact_id])
    @users = @pact.users
  end

  def chat
    @pact = Pact.find(params[:pact_id])
    if params[:week_id]
      @week = Week.find(params[:week_id])
      @messages = @week.messages
    else
      @messages = @pact.messages
    end
  end

  def chat_week
    @pact = Pact.find(params[:pact_id])
    if params[:week_id]
      @week = Week.find(params[:week_id])
      @messages = @week.messages
    else
      @messages = @pact.messages
    end
  end

  def add_users 
    @pact = Pact.find(params[:id])
  end

  def add_penalties
    @pact = Pact.find(params[:id])
  end

  def add_goals
    @pact = Pact.find(params[:id])
    @goals = @pact.goals
  end


  def import
    begin
      @pact = Pact.find(params[:id])
      uploaded_file = Pact.import(params[:file], @pact)
      flash[:notice] = "Import successful"
      redirect_to pact_path(@pact.id)
    # uncomment below along with user logic in chat import in order to throw an error when user has not been created yet
    # rescue => exception
    #   flash[:notice] = "There was a problem uploading the chat. Not all users were added to the Pact, please add them."
    #   redirect_to pact_path(@pact.id)
    end
  end

  private

  def pact_params
    params.require(:pact).permit(
      :id,
      :end_date, 
      :is_active, 
      :pact_name, 
      :start_date, 
      :attachment,
      pact_photos_attributes: [:id, :photo, :pact_photo_cache, :_destroy],
      penalties_attributes:[:id, :pact_id, :penalty, :goal_days], 
      user_ids:[], 
      goals_attributes:[:id, :pact_id, :goal_days, :user_id, :week_id],
      messages_attributes:[:id, :pact_id, :user_id, :message, :date_sent, :photo_url, :media, :image, :video, :date, :time, :msg_date_time, :sender, :user, :week_id],
      workouts_attributes:[:id, :distance, :duration, :is_makeup_workout, :pace, :video1, :video2, :workout_description, :workout_name, :sent, :photo_id, :user_id, :week_id, :message_id],
      payments_attributes:[:id, :owed, :paid, :user_id, :pact_id]
      )
  end 

end
