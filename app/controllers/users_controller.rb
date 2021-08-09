class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.all.page params[:page]
  end

  def new
    @user = User.new
  end

  def show
    return if @user

    flash[:error] = t "users.show.not_found"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.activate.message"
      redirect_to root_path
    else
      flash[:error] = t "users.signup.fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.update.success"
      redirect_to @user
    else
      flash[:danger] = t "users.update.fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.delete.success"
    else
      flash[:danger] = t "users.delete.fail"
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit User::PERMITTED
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "session.login.require"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]
  end
end
