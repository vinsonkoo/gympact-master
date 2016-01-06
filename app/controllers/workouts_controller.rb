class WorkoutsController < ApplicationController
  def index
  end

  def show
    @workout = Workout.find(params[:id])
  end

  private

  def workouts_params
    params.require(:workouts).permit(:distance, :pace, :duration, :video1, :video2, :workout_name, :workout_description, :is_makeup_workout, :user_id, :week_id, :sent, :pact_id, :message_id)
  end
end
