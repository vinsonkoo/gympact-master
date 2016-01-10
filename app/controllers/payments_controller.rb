class PaymentsController < ApplicationController
  def index
  end

  def new
  end

  def show
  end

  private
  
  def message_params
    params.require(:payment).permit(:payment, :user_id, :pact_id)
  end
end
