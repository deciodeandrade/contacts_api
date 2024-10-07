class ContactsController < ApiController
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    @contacts = current_user.contacts.order(name: :asc)
    render json: @contacts
  end

  def show
    render json: @contact
  end

  def create
    @contact = current_user.contacts.new(contact_params)

    # Obtenção da latitude e longitude via GoogleMapsService
    coordinates = GoogleMapsService.fetch_lat_long(full_address(@contact), ENV['GOOGLE_MAPS_API_KEY'])
    if coordinates[:error].nil?
      @contact.latitude = coordinates[:latitude]
      @contact.longitude = coordinates[:longitude]
    else
      render json: { error: "Endereço inválido: #{coordinates[:error]}" }, status: :unprocessable_entity and return
    end

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def update
    # Atualiza a latitude e longitude ao atualizar o endereço
    coordinates = GoogleMapsService.fetch_lat_long(full_address(@contact), ENV['GOOGLE_MAPS_API_KEY'])
    if coordinates[:error].nil?
      @contact.latitude = coordinates[:latitude]
      @contact.longitude = coordinates[:longitude]
    else
      render json: { error: "Endereço inválido: #{coordinates[:error]}" }, status: :unprocessable_entity and return
    end

    if @contact.update(contact_params)
      render json: @contact
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
    @contact = current_user.contacts.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :cpf, :street, :number, :complement, :neighborhood, :city, :state, :cep)
  end

  # Concatena os campos para formar o endereço completo que será enviado ao GoogleMapsService
  def full_address(contact)
    "#{contact.street}, #{contact.number}, #{contact.neighborhood}, #{contact.city}, #{contact.state}, #{contact.cep}"
  end
end
