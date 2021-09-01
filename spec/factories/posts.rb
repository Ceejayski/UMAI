FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "MyString#{n}" }
    sequence(:content) { |n| "MyString#{n}" }
    sequence(:avg_ratings) { |n| n }
    association :user
  end
end
