require 'rails_helper'

RSpec.describe "Contacts API", type: :request do
  # Método para fazer o parse do JSON
  def json
    JSON.parse(response.body)
  end

  # Criação de um usuário e autenticação
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  # Parâmetros válidos para criar um contato
  let(:valid_attributes) do
    { 
      contact: {
        name: 'John Doe',
        email: "hsjdhsjb@example.com",
        cpf: "68302704059",
        address_attributes: {
          street: 'Avenida Marginal Direita do Tietê',
          number: '123',
          neighborhood: 'Vila Jaguara',
          city: 'São Paulo',
          state: 'SP',
          cep: '05118-100'
        } 
      } 
    }
  end

  # Parâmetros inválidos
  let(:invalid_attributes) do
    { 
      contact: {
        name: '', 
        address_attributes: { 
          street: '', 
          number: '', 
          neighborhood: '', 
          city: '', 
          state: '', 
          cep: '' 
        } 
      } 
    }
  end

  # Criação de um contato antes dos testes
  let!(:contact) { create(:contact, user: user) }
  let(:contact_id) { contact.id }

  describe 'GET /contacts' do
    context 'when user is authenticated' do
      before { get '/contacts', headers: auth_headers }
      
      it 'returns a list of contacts' do
        expect(json).not_to be_empty
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      before { get '/contacts' }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /contacts/:id' do
    context 'when the record exists and user is authenticated' do
      before { get "/contacts/#{contact_id}", headers: auth_headers }

      it 'returns the contact' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(contact_id)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      it 'returns status code 404' do
        get "/contacts/9999", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(json['message']).to match(/Contact not found/)
      end
    end

    context 'when user is not authenticated' do
      before { get "/contacts/#{contact_id}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /contacts' do
    context 'when the request is valid and user is authenticated' do
      before { post '/contacts', params: valid_attributes, headers: auth_headers }

      it 'creates a contact' do
        expect(json['name']).to eq('John Doe') 
        expect(json['address']['street']).to eq('Avenida Marginal Direita do Tietê') # Verificação do endereço
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before { post '/contacts', params: invalid_attributes, headers: auth_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not authenticated' do
      before { post '/contacts', params: valid_attributes }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /contacts/:id' do
    context 'when the record exists and user is authenticated' do
      let(:updated_attributes) do
        { 
          contact: { 
            name: 'Jane Doe',
            email: "hsjdhsjb@example.com",
            cpf: "68302704059",
            address_attributes: {
              street: 'Rua Vitorino Carmilo',
              number: '122',
              neighborhood: 'Barra Funda',
              city: 'São Paulo',
              state: 'SP',
              cep: '01153-000'
            }
          }
        }
      end

      before { put "/contacts/#{contact_id}", params: updated_attributes, headers: auth_headers }

      it 'updates the record' do
        expect(json['name']).to eq('Jane Doe')
        expect(json['address']['street']).to eq('Rua Vitorino Carmilo') # Verificação do endereço atualizado
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      let(:contact_id) { 9999 }
      before { put "/contacts/#{contact_id}", params: valid_attributes, headers: auth_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do
      let(:updated_attributes) { { contact: { name: 'Jane Doe' } } }
      before { put "/contacts/#{contact_id}", params: updated_attributes }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /contacts/:id' do
    context 'when the record exists and user is authenticated' do
      before { delete "/contacts/#{contact_id}", headers: auth_headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the record does not exist' do
      let(:contact_id) { 9999 }
      before { delete "/contacts/#{contact_id}", headers: auth_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do
      before { delete "/contacts/#{contact_id}" }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
