class SignupController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      set_cookies
      render json: @user, status: :created
    else
      render json: {errors: @user.errors.full_messages}
    end
  end

  private

  def get_token
    JwtTokenService.encode({:id => @user.id})
  end

  def set_cookies
    cookies[:auth_token] = {
      value: get_token,
      httponly: true,   # Makes the cookie HTTP-only
      secure: Rails.env.production?,  # Ensure it's only sent over HTTPS in production
      expires: 1.day.from_now, # Set expiration if needed
      # same_site: :none
      same_site: Rails.env.production? ? :none : :lax
    }
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end