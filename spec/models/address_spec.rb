require 'rails_helper'

RSpec.describe Address, type: :model do
  # Associações
  it { should belong_to(:contact) }

  # Validações
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:cep) }

  # Teste de criação de endereço válido
  it "é válido com atributos válidos" do
    address = build(:address)
    expect(address).to be_valid
  end

  # Teste de criação de endereço inválido
  it "é inválido sem um número" do
    address = build(:address, number: nil)
    expect(address).to_not be_valid
  end
end
