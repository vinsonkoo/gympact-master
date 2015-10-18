class GoalsController < ApplicationController
  def index
  end

  private

  def goals_params
    params.require(:goal).permit(:goal, :user_id, :pact_id, :week_id)
  end
end
