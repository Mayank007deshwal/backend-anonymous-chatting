# app/channels/matchmaking_channel.rb
class MatchmakingChannel < ApplicationCable::Channel
  @@waiting_users = []

  def subscribed
    stream_for current_user
  end

  # def find_stranger
  #   if @@waiting_users.empty?
  #     @@waiting_users << current_user
  #     self.class.broadcast_to(current_user, { status: 'waiting' })
  #   else
  #     stranger = @@waiting_users.pop
  #     room_id = SecureRandom.uuid
  #     self.class.broadcast_to(current_user, { status: 'found', room_id: room_id })
  #     self.class.broadcast_to(stranger, { status: 'found', room_id: room_id })
  #   end
  # end

  # def unsubscribed
  #   @@waiting_users.delete(current_user)
  # end

  def find_stranger
    # Retrieve the waiting users from Redis

    waiting_users = Redis.current.smembers("waiting_users")
  
    if waiting_users.empty?
      # If no waiting users, add the current user to Redis
      Redis.current.sadd("waiting_users", current_user)
      self.class.broadcast_to(current_user, { status: 'waiting' })
    else
      # Pop a user from Redis (Note: Redis does not support pop directly)
      # You can use srandmember to get a random waiting user
      stranger_id = Redis.current.srandmember("waiting_users")
      
      # Remove the stranger from Redis
      Redis.current.srem("waiting_users", stranger_id)
  
      room_id = SecureRandom.uuid
      self.class.broadcast_to(current_user, { status: 'found', room_id: room_id })
      self.class.broadcast_to(stranger_id, { status: 'found', room_id: room_id })
    end
  end
  
  def unsubscribed
    # Remove the current user from Redis when unsubscribing
    Redis.current.srem("waiting_users", current_user.id)
  end
  

end
