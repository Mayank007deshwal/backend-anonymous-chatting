# config/initializers/cable.rb

Rails.application.config.action_cable.allowed_request_origins = [ENV['FRONTEND_BASE_URL']]
