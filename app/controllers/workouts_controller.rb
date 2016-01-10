class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.all
  end

  def edit 
    @workout = Workout.find(params[:id])
    @users = Pact.find_by(id: @workout.pact_id).users
  end

  def update
    @workout = Workout.find(params[:id])
    @users = Pact.find_by(id: @workout.pact_id).users
    @workout.update(workouts_params)
    redirect_to workout_path
  end

  def show
    @workout = Workout.find(params[:id])
    @message = Message.find_by(id: @workout.message_id)
  end
  
  def copy
    @existing_workout = Workout.find(params[:id])
    @workout = @existing_workout.dup
    @workout.save
    redirect_to edit_workout_path(@workout)
  end

  private

  def workouts_params
    params.require(:workout).permit(:distance, :pace, :duration, :video1, :video2, :workout_name, :workout_description, :is_makeup_workout, :user_id, :week_id, :sent, :pact_id, :message_id)
  end
end
