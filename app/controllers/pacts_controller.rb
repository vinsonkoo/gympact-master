class PactsController < ApplicationController
	
  def new
    @pact = Pact.new
  end

  def create
    @pact = Pact.new(pact_params)
    if @pact.save
      redirect_to @pact
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
    @week = Week.all
	end

  private

  def pact_params
    params.require(:pact).permit(:end_date, :is_active, :pact_name, :start_date)
  end	

  def week_params
    params.require(:week).permit(:start_date, :end_date, :pact_id, :week_number)
  end
end
