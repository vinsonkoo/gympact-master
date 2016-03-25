class GoalsController < ApplicationController
  
  def new
    @goal = Goal.new
    @users = User.all
    @pacts = Pact.all
    @goal_options = Pact.all.map{|p| [ p.pact_name, p.id ] }
    @pact = Pact.find_by(id: @goal.pact_id)
  end

  def create
    @goal = Goal.new(goal_params)
    if @goal.save
      redirect_to @goal
    else
      render 'new'
    end
  end

  def edit
    @pact = Pact.find(params[:pact_id])
    @goal = Goal.find(params[:id])
  end

  def update
    @pact = Pact.find(params[:pact_id])
    @goal = Goal.find(params[:id])
    @goal.update(goal_params)
    redirect_to pact_goal_path
  end

  def index
    @pact = Pact.find(params[:pact_id])
    @goals = @pact.goals
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    respond_to do |format|
      format.html { redirect_to pact_url }
      format.json { head :no_content }
    end
  end

  def show
    @goal = Goal.find(params[:id])
    @pact = Pact.find_by(id: @goal.pact_id)
  end

  

  private

  def goal_params
    params.require(:goal).permit(:goal_days, :user_id, :pact_id, :week_id)
  end
end
