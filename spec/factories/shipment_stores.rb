# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipment_store do
    order_id "MyString"
    user nil
    awb "MyString"
    label_url "MyString"
    order_number "MyString"
  end
end
