class ChatsController < ApplicationController
  include AuthToken
  before_action :validate_token  # Ensure the user is logged in

  def index
    conversation = Conversation.find_by(user_1: current_user.id, user_2: params[:receipient_id]) ||
                   Conversation.find_by(user_1: params[:receipient_id], user_2: current_user.id)
    if conversation
      render json: conversation.chats
    else
      render json: []
    end

  end

  def create
    recipient = User.find(params[:recipient_id])

    
    ################################################
    # Need to be completed
    # if params[:conversation_id]
    #   message = Message.new(message_params.merge({sender: current_user, conversation_id: params[:conversation_id]}))
    # end


    conversation = find_or_create_conversation(current_user, recipient)
    
    message = conversation.chats.new(message_params)
    message.sender = current_user

    if message.save
      render json: message, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def current_user
    @current_user ||= User.find(@token["id"]) if @token.present?
  end

  def message_params
    params.require(:chat).permit(:content)
  end

  def find_or_create_conversation(user1, user2)
    # Find existing conversation between the two users
    Conversation.find_by(user_1: user1, user_2: user2) ||
    Conversation.find_by(user_1: user2, user_2: user1) ||
    # Create a new conversation if none exists
    Conversation.create(user_1: user1, user_2: user2)
  end
end
