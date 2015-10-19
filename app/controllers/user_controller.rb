class UserController < ApplicationController

  def index
    @users = User.all
    @messages = Message.all
  end

  def show
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)  
    if @user.save
      # handle successful save
      redirect_to root_url, notice: "Saved"
    else
      render 'new'
    end
  end


  private
  
  def user_params
    params.require(:user).permit(:first_name, :username, :last_name, :avatar_url, :email)
  end
end
