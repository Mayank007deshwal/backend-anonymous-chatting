class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "conversation_channel_#{params[:conversation_id]}"

    Redis.current.sadd("conversation_channel_#{params[:conversation_id]}", params[:current_user_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Redis.current.srem("conversation_channel_#{params[:conversation_id]}", params[:current_user_id])
  end
end
