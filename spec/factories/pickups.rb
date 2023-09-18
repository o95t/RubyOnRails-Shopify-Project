# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pickup do
    pickup_address_line1 "MyString"
    pickup_address_line2 "MyString"
    pickup_address_line3 "MyString"
    pickup_cellphone "MyString"
    pickup_company_name "MyString"
    pickup_country_code "MyString"
    pickup_email "MyString"
    pickup_post_code "MyString"
    pickup_person_name "MyString"
    pickup_location "MyString"
    ready_time "2013-06-25 16:20:45"
    last_pickup_time "2013-06-25 16:20:45"
    closing_time "2013-06-25 16:20:45"
    reference1 "MyString"
    status "MyString"
    product_group "MyString"
    number_of_shipments "MyString"
    payment "MyString"
  end
end
