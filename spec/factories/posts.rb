FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "MyString#{n}" }
    sequence(:content) { |n| "MyString#{n}" }
    association :user
  end
end
