require 'rails_helper'

RSpec.describe "Addresses API", type: :request do
  # Método para fazer o parse do JSON
  def json
    JSON.parse(response.body)
  end

  let(:user) { create(:user) }  # Cria um usuário com FactoryBot
  let(:auth_headers) { user.create_new_auth_token }  # Obtém os cabeçalhos de autenticação

  describe 'GET /addresses/search_by_cep' do
    context 'when the cep is valid' do
      let(:valid_cep) { '01001-000' }  # Um CEP de exemplo
      let(:address_data) do
        {
          street: 'Praça da Sé',
          neighborhood: 'Sé',
          city: 'São Paulo',
          state: 'SP',
          cep: valid_cep
        }
      end

      before do
        allow(ViaCepService).to receive(:fetch_address).with(valid_cep).and_return(address_data)
        get "/addresses/search_by_cep?cep=#{valid_cep}", headers: auth_headers
      end

      it 'returns the address data' do
        expect(response).to have_http_status(:ok)
        expect(json).to include('street', 'neighborhood', 'city', 'state', 'cep')
        expect(json['street']).to eq('Praça da Sé')
      end
    end

    context 'when the cep is invalid' do
      let(:invalid_cep) { '00000-000' }

      before do
        allow(ViaCepService).to receive(:fetch_address).with(invalid_cep).and_return(error: 'Invalid CEP')
        get "/addresses/search_by_cep?cep=#{invalid_cep}", headers: auth_headers
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq('Invalid CEP')
      end
    end
  end

  describe 'GET /addresses/suggestions' do
    context 'when the request is valid' do
      let(:valid_params) do
        {
          uf: 'SP',
          city: 'São Paulo',
          address_fragment: 'Rua'
        }
      end

      let(:suggestions_data) do
        [
          { 'name' => 'Rua da Consolação', 'id' => 1 },
          { 'name' => 'Rua da Liberdade', 'id' => 2 }
        ]
      end

      before do
        allow(GoogleMapsService).to receive(:fetch_address_suggestions)
          .with("#{valid_params[:address_fragment]}, #{valid_params[:city]}, #{valid_params[:uf]}", ENV['GOOGLE_MAPS_API_KEY'])
          .and_return(suggestions: suggestions_data)
        get "/addresses/suggestions?#{URI.encode_www_form(valid_params)}", headers: auth_headers
      end

      it 'returns address suggestions' do
        expect(response).to have_http_status(:ok)
        expect(json).to eq(suggestions_data)
      end
    end

    context 'when there is an error fetching suggestions' do
      let(:invalid_params) do
        {
          uf: 'SP',
          city: 'São Paulo',
          address_fragment: 'Rua'
        }
      end

      before do
        allow(GoogleMapsService).to receive(:fetch_address_suggestions)
          .with("#{invalid_params[:address_fragment]}, #{invalid_params[:city]}, #{invalid_params[:uf]}", ENV['GOOGLE_MAPS_API_KEY'])
          .and_return(error: 'Error fetching suggestions')
        get "/addresses/suggestions?#{URI.encode_www_form(invalid_params)}", headers: auth_headers
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['error']).to eq('Error fetching suggestions')
      end
    end
  end
end
