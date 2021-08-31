FactoryBot.define do
  factory :rating do
    sequence(:value) {|n| 2}
    association :post
    association :user
  end
end
