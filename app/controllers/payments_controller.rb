class PaymentsController < ApplicationController
  def index
    @payments = Payment.all
  end

  def create
    @payment = Payment.new(payment_params)
    if @pact.save
      redirect_to @payment
    else
      render 'new'
    end
  end

  def new
    @payment = Payment.new
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])
    @payment.update(payment_params)
    @payment.owed = @payment.owed - @payment.paid
    redirect_to pact_path(@payment.pact_id)
  end
  def show
    @payment = Payment.find(params[:id])
  end

  private
  
  def payment_params
    params.require(:payment).permit(:owed, :paid, :user_id, :pact_id)
  end
end
