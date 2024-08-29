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
    all_user_ids = User.pluck(:id)
    subscribed_user_ids = Redis.current.smembers("conversation_channel_#{conversation_id}").map(&:to_i)
    non_subscribed_user_ids = all_user_ids - subscribed_user_ids
    
    non_subscribed_users = User.where(id: non_subscribed_user_ids)
    
    non_subscribed_users.each do |user|
      # Trigger notification for each non-subscribed user
      # FcmService.new(user.fcm_token, "New Message", "Check out the latest message in the post!").send_notification
      SendNotificationJob.perform_later(
        "ftu1ogFzryNZhK-aB5ZIKX:APA91bGLnlnA3ddTCxGuNt-Av8TFdlTNeia-tTxQGca35bbgF1Lw0Np3m4lgOFTATd_yNNYxaLeVszF4839u8qUXakGz3393JhvgLfZnqausGBtwBpjX_jkz8yJxvH2JmVsfbhxwY79n",
        "New message from #{sender.name}",content
      )
    end
  end
  
end
