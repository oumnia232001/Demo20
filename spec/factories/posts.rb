FactoryBot.define do
  factory :post do
    title { "Default Title" }
    content { "Default Content" }
    association :user  # Associe un utilisateur créé via la factory de user
  end
end
