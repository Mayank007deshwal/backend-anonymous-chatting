module AuthToken
  def validate_token
# byebug
    token = cookies[:auth_token]

    begin
      @token = JwtTokenService.decode(token)
    rescue JWT::ExpiredSignature
      puts "Token has expired"
      return render json: { errors: [token: 'Token has Expired'] },
      status: :unauthorized
    rescue JWT::DecodeError => e
      return render json: { errors: [token: 'Invalid token'] },
        status: :bad_request
    end
  end
end