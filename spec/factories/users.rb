FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "MyString#{n}" }
    sequence(:password_digest) { |n| "MyString#{n}" }
  end
end
