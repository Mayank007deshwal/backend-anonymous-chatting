class UsersController < ApplicationController
  include AuthToken
  before_action :validate_token 
  
  def index
    all_users = User.where.not(id: current_user.id)
    render json: all_users
  end

  def add_device_token
    if(current_user.devise_token)
      devise_token = current_user.devise_token
      devise_token.update(devise_id: params[:devise_id])
      render json: devise_token
    else
      # devise_token = current_user.devise_token.create({devise_id: params[:devise_id]})
      devise_token = DeviseToken.create(user_id: current_user.id, devise_id: params[:devise_id])
      render json: devise_token
    end
  end

  private

  def current_user
    @current_user ||= User.find(@token["id"]) if @token.present?
  end
end
