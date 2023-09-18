FactoryGirl.define do 
  factory :user do 
    sequence(:shop_name) { |n| "Test Shop #{n}" }
    sequence(:shop_url) { |n| "test_shop_#{n}.myshopify.com" }
    sequence(:email) { |n| "test_shop_#{n}@example.com"}
    password 'password'
    account_number '123456789'
    account_pin '123456'
    account_entity 'BOM'
    account_country_code 'IN'    
  end
end