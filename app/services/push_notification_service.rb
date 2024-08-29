class PushNotificationService

  def initialize(token, title, body)
    @token = token
    @title = title
    @body = body
  end

  def send_notification
    message = {
      'token': @token,
      'notification': {
        title: @title,
        body: @body
    }
  }

  FCM_CLIENT.send_v1(message)
  end
end