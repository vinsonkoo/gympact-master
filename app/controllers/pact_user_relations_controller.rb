class PactUserRelationsController < ApplicationController
  def index
  end

  # def new
  #   @pact_user_relation = PactUserRelation.new
  #   @pacts = Pact.all
  #   @users = User.all
  #   @pact_user_relation_options = Pact.all.map{|p| [ p.pact_name, p.id ] }
  # end

  # def create
  #   @pact_user_relation = PactUserRelation.new(pact_user_relations_params)
  #   @pacts = Pact.all
  #   @users = User.all
  #   if !@pact_user_relation.valid?
  #     flash[:error] = @pact_user_relation.errors.full_messages.join("<br>").html_safe
  #   end
  #   if @pact_user_relation.save
  #     redirect_to @pact_user_relation
  #   else
  #     render 'new'
  #   end
  # end

  def new
    @relations = []
    @pacts = Pact.all
    @users = User.all
    @relations << PactUserRelation.new
    @pact_user_relation_options = Pact.all.map{|p| [ p.pact_name, p.id ] }
  end

  def create
    @relations = []
    params["relations"].each do |pact_user_relation|
      PactUserRelation.create(relations_params(pact_user_relation))
    end
  end

  def update
    @pact_user_relation = PactUserRelation.find(params[:id])
    @pact_user_relation.update(pact_user_relation_params)
    redirect_to @pact_user_relation
  end

  def show
    @pact_user_relation = PactUserRelation.find(params[:id])
    @user = User.all
    @pact = Pact.all
  end

  private
  
  def pact_user_relation_params
    params.require(:pact_user_relation).permit(:pact_id, :user_id)
  end

  def pact_params
    params.require(:pact).permit(:pact_id)
  end
  def user_params
    params.require(:user).permit(:user_id)
  end

  def relations_params(my_params)
    my_params.permit(:pact_id, :user_id)
  end
  
end
