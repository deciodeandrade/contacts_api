# app/controllers/addresses_controller.rb
class AddressesController < ApplicationController
  def search_by_cep
    cep = params[:cep]
    address_data = ViaCepService.fetch_address(cep)

    if address_data[:error].nil?
      render json: address_data, status: :ok
    else
      render json: { error: address_data[:error] }, status: :unprocessable_entity
    end
  end

  def suggestions
    # Obtemos os parâmetros de busca
    uf = params[:uf]
    city = params[:city]
    address_fragment = params[:address_fragment]

    # Montamos a query para a API do Google Maps
    full_address = "#{address_fragment}, #{city}, #{uf}"
    response = GoogleMapsService.fetch_address_suggestions(full_address, ENV['GOOGLE_MAPS_API_KEY'])

    if response[:error].nil?
      render json: response[:suggestions], status: :ok
    else
      render json: { error: response[:error] }, status: :unprocessable_entity
    end
  end
end
