class MessagesController < ApplicationController
  before_action :set_post

  def index
    messages = @post.messages
    render json: messages
  end

  def show
    message = @post.messages.find(params[:id])
    render json: messages
  end

  def create
    message = @post.messages.build(message_params)
    if message.save
      render json: message
    else
      render json: {errors: message.errors.full_messages}
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
