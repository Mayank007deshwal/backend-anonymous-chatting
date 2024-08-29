class ConversationController < ApplicationController
  before_action :validate_token
  
  def index
    conversations = Conversation.where(user_1: current_user.id) ||
                    Conversation.find_by(user_2: current_user.id)
    render json: conversations
  end

  private

  def current_user
    @current_user ||= User.find(@token["id"]) if @token.present?
  end
end
