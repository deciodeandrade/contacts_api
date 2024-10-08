FactoryBot.define do
  factory :address do
    street { "Rua Jacauna" }
    number { "258" }
    complement { "Apto 301" }
    neighborhood { "Iputinga" }
    city { "Recife" }
    state { "PE" }
    cep { "50670-160" }
    latitude { -8.0455875 }
    longitude { -34.938081 }

    association :contact
  end
end
