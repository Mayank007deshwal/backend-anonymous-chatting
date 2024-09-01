class Post < ApplicationRecord
  has_one_attached :image
  validates :title, presence: true
  validates :description, presence: true

  # after_create :send_notification

  has_many :messages
  # after_create :broadcast_creation
  # private

  # def send_notification
  #   SendNotificationJob.perform_later(
  #     "ftu1ogFzryNZhK-aB5ZIKX:APA91bGLnlnA3ddTCxGuNt-Av8TFdlTNeia-tTxQGca35bbgF1Lw0Np3m4lgOFTATd_yNNYxaLeVszF4839u8qUXakGz3393JhvgLfZnqausGBtwBpjX_jkz8yJxvH2JmVsfbhxwY79n",
  #     title,
  #     description
  #   )
  # end


  # def broadcast_creation
  #   PostChannel.broadcast_to(self, { message: "Post created", post: self })
  # end

  # def broadcast_creation
  #   ActionCable.server.broadcast("post_channel_#{self.id}", { message: "Post created", post: self })
  # end
end
