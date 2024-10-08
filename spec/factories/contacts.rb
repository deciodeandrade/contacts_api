FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    cpf { CPF.generate }  # CPF gem para gerar um CPF válido

    association :user

    after(:build) do |contact|
      contact.address = build(:address, contact: contact)
    end
  end
end
