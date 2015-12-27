class WeeksController < ApplicationController
	def show
    @pact = Pact.find(params[:pact_id])
		@week = Week.find(params[:id])
    @previous_week = @week.get_previous_week
    @next_week = @week.get_next_week
    @users = @pact.users
  end

  def email
  	# put variables that you need in /email/:pact_id/:week_id here
  end

  private

  def weeks_params
    params.require(:week).permit(:end_date, :start_date, :week_number, :pact_id)
  end
  
end
