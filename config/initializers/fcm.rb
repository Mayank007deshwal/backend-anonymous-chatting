require 'fcm'

FCM_CLIENT = FCM.new(
  ENV['FCM_SERVER_KEY'],
  Rails.root.join('test-pro-007-cd2a9a4d746f.json').to_s,
  "test-pro-007"
)