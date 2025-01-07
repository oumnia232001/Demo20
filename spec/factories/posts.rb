FactoryBot.define do
  factory :post do
    title { "Default Title" }
    content { "Default Content" }
    association :user  
  end
end
