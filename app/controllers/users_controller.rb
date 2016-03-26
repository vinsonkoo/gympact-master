class UsersController < ApplicationController

  def index
    @pact = Pact.find_by(params[:id])
    @users = @pact.users
  end

  def edit
    @pact = Pact.find_by(params[:id])
    @user = @pact.users.find_by(params[:id])
  end



end
