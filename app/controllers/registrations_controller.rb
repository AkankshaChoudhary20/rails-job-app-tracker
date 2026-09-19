class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to root_path and return if logged_in?

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created. Welcome!"
    else
      render "registrations/new", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
