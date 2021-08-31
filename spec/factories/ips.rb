FactoryBot.define do
  factory :ip do
    ip_address { "11.2.2.3.4" }
    login {'user'}
    association :post
    
  end
end
