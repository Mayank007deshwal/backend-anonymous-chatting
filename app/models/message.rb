class Message < ApplicationRecord
  belongs_to :post

  after_create :broadcast_creation

  private
  def broadcast_creation
    ActionCable.server.broadcast("post_channel_#{post_id}", {message: self })
  end
end
