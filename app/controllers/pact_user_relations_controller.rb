class PactUserRelationsController < ApplicationController
  def index
  end

  private
  
  def pact_user_relations_params
    params.require(:pact_user_relations).permit(:pact_id, :user_id)
  end
end
