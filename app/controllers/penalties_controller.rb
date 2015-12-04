class PenaltiesController < ApplicationController
  def new
  end

  def create
  end

  def index
  end

  def show
  end

  private

  def penalty_params
    params.require(:penalty).permit(:goal, :penalty, :pact_id)
  end
  
end
