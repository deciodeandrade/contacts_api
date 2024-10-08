class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :authenticate_user!, only: [:destroy]

  def destroy
    # Pega a senha enviada no corpo da requisição
    password = params[:password]

    # Verifica se a senha é válida
    if current_user.valid_password?(password)
      # Exclui a conta se a senha estiver correta
      current_user.destroy
      render json: { message: 'Conta excluída com sucesso.' }, status: :ok
    else
      # Se a senha for inválida, retorna um erro
      render json: { error: 'Senha inválida. A conta não foi excluída.' }, status: :unprocessable_entity
    end
  end
end
