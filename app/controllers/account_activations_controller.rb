class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if check_activatable user
      user.activate
      log_in user
      flash[:success] = t "users.activate.activated"
      redirect_to user
    else
      flash[:danger] = t "users.activate.invalid"
      redirect_to root_path
    end
  end

  private
  def check_activatable user
    user && !user.activated && user.authenticated?(:activation, params[:id])
  end
end
