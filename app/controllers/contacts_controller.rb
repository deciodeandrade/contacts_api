class ContactsController < ApiController
  has_scope :search

  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    @contacts = apply_scopes(current_user.contacts)
                  .includes(:address)
                  .paginate(page: params[:page], per_page: params[:per_page])
                  .order(name: :asc)

    render json: @contacts, include: :address
  end

  def show
    render json: @contact, include: :address
  end

  def create
    @contact = current_user.contacts.new(contact_params)
  
    # Obtém as coordenadas via GoogleMapsService
    if set_latitude_longitude(@contact.address)
      if @contact.save
        render json: @contact, include: :address, status: :created
      else
        render json: @contact.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Endereço inválido." }, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      # Atualiza a latitude e longitude ao atualizar o endereço
      set_latitude_longitude(@contact.address)

      render json: @contact, include: :address
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    head :no_content
  end

  private

  def set_contact
    @contact = current_user.contacts.includes(:address).find(params[:id])
  end

  # Parâmetros permitidos para criar/atualizar contato e endereço
  def contact_params
    params.require(:contact).permit(:name, :email, :cpf, address_attributes: [:street, :number, :complement, :neighborhood, :city, :state, :cep])
  end

  # Define latitude e longitude para o endereço usando GoogleMapsService
  def set_latitude_longitude(address)
    full_address = "#{address.street}, #{address.number}, #{address.neighborhood}, #{address.city}, #{address.state}, #{address.cep}"
    
    coordinates = GoogleMapsService.fetch_lat_long(full_address, ENV['GOOGLE_MAPS_API_KEY'])
  
    if coordinates[:error].nil?
      address.latitude = coordinates[:latitude]
      address.longitude = coordinates[:longitude]
      true # Retorna verdadeiro se as coordenadas foram definidas com sucesso
    else
      false # Retorna falso se houve um erro
    end
  end
end
