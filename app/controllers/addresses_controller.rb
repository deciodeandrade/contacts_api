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
end
