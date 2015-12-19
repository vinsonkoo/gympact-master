class PactsController < ApplicationController
	
  def new
    @pact = Pact.new
  end

  def create
    @pact = Pact.new(pact_params)
    if @pact.save
      redirect_to @pact
      # redirect_to 'add_users_path'
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
    @pact.update(pact_params)
    redirect_to @pact
  end

  def all 
    @pact = Pact.all
  end

  def index
    @pact = Pact.all
  end

  def show
    @pact = Pact.find(params[:id])
    @weeks = Week.all
    @users = @pact.users
    # @goals = @pact.user.goals
	end

  def add_users 
    @pact = Pact.find(params[:id])
  end

  def add_penalty 
    @pact = Pact.find(params[:id])
    # @penalty = Penalty.new
    # 8.times{@pact.penalties.build}

    # if @pact.save
    #   redirect_to @pact
    #   # redirect_to 'add_users_path'
    # else
    #   # render 'new'
    # end
  end

  def add_goals
    @pact = Pact.find(params[:id])
  end

  private

  def pact_params
    params.require(:pact).permit(
      :id,
      :end_date, 
      :is_active, 
      :pact_name, 
      :start_date, 
      penalties_attributes:[:id, :pact_id, :penalty, :goal_days], 
      user_ids:[], 
      goals_attributes:[:id, :pact_id, :goal, :user_id, :week_id]
      )
  end	

  def week_params
    params.require(:week).permit(:start_date, :end_date, :pact_id, :week_number)
  end
end
