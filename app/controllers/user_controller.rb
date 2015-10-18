class UserController < ApplicationController


  private
  
  def user_params
    params.require(:user).permit(:first_name, :username, :last_name, :avatar_url, :email)
  end
end
