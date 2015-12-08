class PenaltiesController < ApplicationController
  def new
    @penalty = Penalty.new
  end

  def create
    @penalty = Penalty.new
    if @penalty.save
      redirect_to penalties_path
    else
      render 'new'
    end
  end

  def index
    @penalty = Penalty.all
  end

  def show
  end

  private

  def penalty_params
    params.require(:penalty).permit(:goal, :penalty, :pact_id)
  end
  
end
