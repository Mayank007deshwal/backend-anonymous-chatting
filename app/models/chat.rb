class Chat < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  after_create :broadcast_creation
  after_create :notify_non_subscribed_users

  private
  def broadcast_creation
    ActionCable.server.broadcast("conversation_channel_#{conversation_id}", {message: self })
  end

  def notify_non_subscribed_users
    subscribed_user_ids = Redis.current.smembers("conversation_channel_#{conversation_id}").map(&:to_i)
    if subscribed_user_ids.length < 2
      if sender_id != conversation.user_1.id
        user_to_send_notification = conversation.user_1
      else
        user_to_send_notification = conversation.user_2
      end

      if user_to_send_notification.devise_token
        SendNotificationJob.perform_later(
          user_to_send_notification.devise_token.devise_id,
          "New message from #{sender.name}",content
        )
      end
    end
  end
  
end
