class PactController < ApplicationController
	def show
	end

  private

  def pact_params
    params.require(:pact).permit(:end_date, :is_active, :pact_name, :start_date)
  end	

end
