class WeekController < ApplicationController
	def show
		# put variables that you need in /week/:pact_id/:week_id here
  end

  def email
  	# put variables that you need in /email/:pact_id/:week_id here
  end

  private

  def week_params
    params.require(:week).permit(:end_date, :start_date, :week_number, :pact_id)
  end
  
end
