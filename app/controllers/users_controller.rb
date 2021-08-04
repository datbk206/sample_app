class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:error] = t "users.show.not_found"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "users.signup.success"
      redirect_to @user
    else
      flash[:error] = t "users.signup.fail"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit User::PERMITTED
  end
end
