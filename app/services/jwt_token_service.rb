require 'jwt'
class JwtTokenService
  class << self
    def encode(data, expiration = nil)
      data = nil unless data.is_a?(Hash)
      data       ||= {}
      expiration ||= 24.hours.from_now
    
      payload = payload_for_token(data, expiration.to_i)

      JWT.encode payload, hmac_secret, algorithm
    end

    def decode(token)
      (JWT.decode token, hmac_secret, true, { algorithm: algorithm })[0]
    end

    private

    def algorithm
      'HS256'
    end

    def hmac_secret
      'your_secret_key@124$%'
    end

    def payload_for_token(data, expiration)
      {
        :exp => expiration
      }.merge(data)
    end
  end
end
