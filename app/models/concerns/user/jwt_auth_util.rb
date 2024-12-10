module User::JwtAuthUtil
  extend ActiveSupport::Concern
  
  # def self.jwt_revoked?(payload, user)
  #   binding.pry
  #   !user.allowlisted_jwts.exists?(payload.slice('jti', 'aud'))
  # end

  # # @see Warden::JWTAuth::Interfaces::RevocationStrategy#revoke_jwt
  # def self.revoke_jwt(payload, user)
  #   binding.pry
  #   jwt = user.allowlisted_jwts.find_by(payload.slice('jti', 'aud'))
  #   jwt.destroy! if jwt
  # end

  # # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
  # def on_jwt_dispatch(_token, payload)
  #   binding.pry
  #   allowlisted_jwts.create!(
  #     jti: payload['jti'],
  #     aud: payload['aud'],
  #     exp: Time.at(payload['exp'].to_i)
  #   )
  # end
end