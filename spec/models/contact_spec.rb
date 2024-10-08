require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { create(:user) }  # Cria um usuário para teste

  # Associações
  it { should have_one(:address).dependent(:destroy) }

  # Nested attributes
  it { should accept_nested_attributes_for(:address) }

  # Validações
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:cpf) }

  it "validates that email is unique within the scope of user_id" do
    # Cria um contato existente
    create(:contact, email: "test@example.com", user: user)  
    # Cria um novo contato com o mesmo email
    contact = build(:contact, email: "test@example.com", user: user)  
    expect(contact).to_not be_valid
    expect(contact.errors[:email]).to include("has already been taken")
  end

  it "validates that cpf is unique within the scope of user_id" do
    cpf = CPF.generate
    # Cria um contato existente
    create(:contact, cpf: cpf, user: user)  
    # Cria um novo contato com o mesmo CPF
    contact = build(:contact, cpf: cpf, user: user)  
    expect(contact).to_not be_valid
    expect(contact.errors[:cpf]).to include("has already been taken")
  end

  # Teste de CPF válido
  it "é inválido com um CPF inválido" do
    # Atribui usuário
    contact = build(:contact, cpf: "123.456.789-00", user: user)  
    expect(contact).to_not be_valid
  end

  # Teste de criação de contato válido
  it "é válido com atributos válidos" do
    # Atribui usuário
    contact = build(:contact, user: user)  
    expect(contact).to be_valid
  end

  # Teste de busca com escopo
  it "retorna contatos que correspondem à query" do
    # Garante CPF válido
    contact1 = create(:contact, name: "John Doe", cpf: CPF.generate, user: user)  
    # Garante CPF válido
    contact2 = create(:contact, name: "Jane Smith", cpf: CPF.generate, user: user)  
  
    result = Contact.search("John")
    expect(result).to include(contact1)
    expect(result).to_not include(contact2)
  end
end
