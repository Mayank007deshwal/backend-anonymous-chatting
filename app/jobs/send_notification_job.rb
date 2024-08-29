class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(token, title, body)
    PushNotificationService.new(token, title, body).send_notification
  end
end
