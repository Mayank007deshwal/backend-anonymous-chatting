require 'fcm'

FCM_CLIENT = FCM.new(
  ENV['FCM_SERVER_KEY'],
  Rails.root.join(ENV['FCM_CREDENTIAL_FILE_PATH']).to_s,
  "test-pro-007"
)