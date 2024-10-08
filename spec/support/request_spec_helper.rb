module RequestSpecHelper
  # Gera headers válidos para autenticação
  def valid_headers
    {
      "Authorization" => token_generator(user.id),  # Gerar o token JWT para o usuário
      "Content-Type" => "application/json"
    }
  end

  # Headers inválidos para teste
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end
