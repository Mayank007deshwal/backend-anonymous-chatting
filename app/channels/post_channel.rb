class PostChannel < ApplicationCable::Channel
  def subscribed
    # post = Post.find(params[:post_id])
    # stream_for post
    stream_from "post_channel_#{params[:post_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def speak(data)
  #   post = Post.find(data["post_id"])
  #   PostChannel.broadcast_to(post, message: data["message"])
  # end
end
