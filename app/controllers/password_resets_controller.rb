class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "users.reset.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "users.reset.not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("users.reset.empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t "users.reset.success"
      redirect_to @user
    else
      flash[:danger] = t "users.reset.fail"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::PASSWORD_PERMITTED
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.reset.not_found"
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "users.reset.invalid"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "users.reset.expired"
    redirect_to new_password_reset_url
  end
end
