class SessionsController < ApplicationController
  before_action :check_logged_in, only: :new

  def new
    render :new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      remember_or_forget user
      redirect_back_or root_path unless user.trainer?
    else
      flash[:danger] = t "controllers.sessions_controller.login_failed"
      redirect_to root_path
    end
  end

  def remember_or_forget user
    if params[:session][:remember_me] == Settings.app.keep_login
      remember user
    else
      forget user
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def check_logged_in
    redirect_to courses_path if logged_in?
  end
end
