class WorkoutsController < ApplicationController
  def index
  end

  private

  def workouts_params
    params.require(:workouts).permit(:distance, :duration, :is_makeup_workout, :pace, :video1, :video2, :workout_description, :workout_name, :sent, :photo_id, :user_id, :week_id)
  end
end
