class ChatController < ApplicationController

  def show
  	@messages = Message.where(pact_id: params[:pact_id]).order(:msg_date_time)
    @pact = Pact.find_by(params[:id]) 
  end

  def index
    @pact = Pact.find_by(params[:id])
    @chat = Chat.all
  end

  private

  def chat_params
    params.require(:chat).permit(:chat, :pact_id)
  end
end