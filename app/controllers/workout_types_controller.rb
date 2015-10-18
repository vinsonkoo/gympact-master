class WorkoutTypesController < ApplicationController
  def index
  end

  private
  
  def workout_types_params
    params.require(:workout_types).permit(:workout_type, :workout_id)
  end
end
