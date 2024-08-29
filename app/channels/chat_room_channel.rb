# app/channels/chat_room_channel.rb
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_#{params[:room_id]}"
  end

  def speak(data)
    ActionCable.server.broadcast("chat_room_#{params[:room_id]}",{ message: data['message'], user_id: data['userId']})
  end
end
