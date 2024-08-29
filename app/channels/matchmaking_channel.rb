# app/channels/matchmaking_channel.rb
class MatchmakingChannel < ApplicationCable::Channel
  @@waiting_users = []

  def subscribed
    stream_for current_user
  end

  def find_stranger
    if @@waiting_users.empty?
      @@waiting_users << current_user
      self.class.broadcast_to(current_user, { status: 'waiting' })
    else
      stranger = @@waiting_users.pop
      room_id = SecureRandom.uuid
      self.class.broadcast_to(current_user, { status: 'found', room_id: room_id })
      self.class.broadcast_to(stranger, { status: 'found', room_id: room_id })
    end
  end

  def unsubscribed
    @@waiting_users.delete(current_user)
  end

end
