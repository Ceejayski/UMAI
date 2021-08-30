FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "MyString#{n}" }
    sequence(:content) { |n| "MyString#{n}" }
    sequence(:ip_address) { |n| "MyString#{n}" }
    association :user
  end
end
