class LoginController < ApplicationController
  include AuthToken
  before_action :validate_token, only: [:is_loggedin], if: -> { cookies[:auth_token].present? }

  def create
    @user = User.find_by_email(user_params[:email])

    is_authenticated = @user.authenticate(user_params[:password]) if @user

    if is_authenticated
      set_cookies
      devise_id = @user.devise_token.try(:devise_id)
      render json: @user.attributes.merge(devise_id: devise_id)
    else
      render json: {errors: "Email and password are not correct!"}
    end
  end

  def is_loggedin
    token = cookies[:auth_token]
    
    return render json: {loggen_in: false} unless token

    user = User.find(@token["id"])
    render json: user
  end

  def logout
    cookies.delete(:auth_token)
    # cookies[:auth_token] = nil
    render json: {is_logout: true}, status: :ok
  end


  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def get_token
    JwtTokenService.encode({id: @user.id})
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
end
