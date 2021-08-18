FactoryBot.define do
  factory :post do
    language
    title { Faker::Marketing.buzzwords }
    summary { Faker::Marketing.buzzwords }
    content { Faker::Marketing.buzzwords }
  end
end
