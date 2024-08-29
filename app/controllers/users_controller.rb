class UsersController < ApplicationController
  include AuthToken
  before_action :validate_token 
  
  def index
    all_users = User.where.not(id: current_user.id)
    render json: all_users
  end

  private

  def current_user
    @current_user ||= User.find(@token["id"]) if @token.present?
  end
end
