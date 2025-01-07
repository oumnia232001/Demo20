require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    full_name { Faker::Name.name }
    avatar_url { Faker::Avatar.image }
    provider { "google_oauth2" }
    uid { SecureRandom.uuid }
    deleted_at { nil } 
  end
end
