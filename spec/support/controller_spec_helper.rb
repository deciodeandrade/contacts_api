module ControllerSpecHelper
  # Gera um token JWT para o usuário
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end
end
