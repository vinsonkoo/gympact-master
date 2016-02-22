class WeeksController < ApplicationController
	def show
    @pact = Pact.find(params[:pact_id])
		@week = Week.find(params[:id])
    @previous_week = @week.get_previous_week
    @next_week = @week.get_next_week
    @users = @pact.users
    @payments = Payment.all
  end

  def update
    @pact = Pact.find(params[:pact_id])
    @week = Week.find(params[:id])
    @week.update(week_params)
    redirect_to pact_week_path
  end

  def email
  	# put variables that you need in /email/:pact_id/:week_id here
  end

  private

  def week_params
    params.require(:week).permit(
      :end_date,
      :start_date,
      :week_number,
      :pact_id,
      payments_attributes:[:id, :owed, :paid, :user_id, :pact_id]
      )
  end
  
end
