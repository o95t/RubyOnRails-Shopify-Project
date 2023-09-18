# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20191119001551) do

  create_table "pickup_stores", :force => true do |t|
    t.integer  "user_id"
    t.string   "aramex_id"
    t.string   "guid"
    t.string   "product_group"
    t.datetime "pickup_datetime"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "reference1"
  end

  add_index "pickup_stores", ["guid"], :name => "index_pickup_stores_on_guid"
  add_index "pickup_stores", ["product_group"], :name => "index_pickup_stores_on_product_group"
  add_index "pickup_stores", ["reference1"], :name => "index_pickup_stores_on_reference1"
  add_index "pickup_stores", ["user_id"], :name => "index_pickup_stores_on_user_id"

  create_table "pickups", :force => true do |t|
    t.string   "pickup_address_line1"
    t.string   "pickup_address_line2"
    t.string   "pickup_address_line3"
    t.string   "pickup_cellphone"
    t.string   "pickup_company_name"
    t.string   "pickup_country_code"
    t.string   "pickup_email"
    t.string   "pickup_post_code"
    t.string   "pickup_person_name"
    t.string   "pickup_location"
    t.datetime "pickup_datetime"
    t.datetime "ready_time"
    t.datetime "last_pickup_time"
    t.datetime "closing_time"
    t.string   "reference1"
    t.string   "status"
    t.string   "product_group"
    t.string   "number_of_shipments"
    t.string   "number_of_pieces"
    t.string   "payment"
    t.string   "shipment_weight"
    t.string   "shipment_volume"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "pickup_city"
    t.string   "product_type"
    t.string   "pickup_post_code_required"
  end

  create_table "shipment_stores", :force => true do |t|
    t.string   "order_id"
    t.integer  "user_id"
    t.string   "awb"
    t.string   "label_url"
    t.string   "order_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "payment_type"
    t.string   "shipment_refer"
    t.string   "receiver_refer"
    t.string   "shipper_refer"
  end

  add_index "shipment_stores", ["awb"], :name => "index_shipment_stores_on_awb", :unique => true
  add_index "shipment_stores", ["order_id"], :name => "index_shipment_stores_on_order_id"
  add_index "shipment_stores", ["order_number"], :name => "index_shipment_stores_on_order_number"
  add_index "shipment_stores", ["payment_type"], :name => "index_shipment_stores_on_payment_type"
  add_index "shipment_stores", ["receiver_refer"], :name => "index_shipment_stores_on_receiver_refer"
  add_index "shipment_stores", ["shipment_refer"], :name => "index_shipment_stores_on_shipment_refer"
  add_index "shipment_stores", ["shipper_refer"], :name => "index_shipment_stores_on_shipper_refer"
  add_index "shipment_stores", ["user_id"], :name => "index_shipment_stores_on_user_id"

  create_table "shipments", :force => true do |t|
    t.string   "payment_type"
    t.string   "payment_options"
    t.string   "shipper_person_name"
    t.string   "shipper_company_name"
    t.string   "shipper_cellphone"
    t.string   "shipper_email"
    t.string   "shipper_address_line1"
    t.string   "shipper_address_line2"
    t.string   "shipper_address_line3"
    t.string   "shipper_city"
    t.string   "shipper_state_code"
    t.string   "shipper_post_code"
    t.string   "shipper_country_code"
    t.string   "receiver_person_name"
    t.string   "receiver_company_name"
    t.string   "receiver_cellphone"
    t.string   "receiver_email"
    t.string   "receiver_address_line1"
    t.string   "receiver_address_line2"
    t.string   "receiver_address_line3"
    t.string   "receiver_city"
    t.string   "receiver_state_code"
    t.string   "receiver_post_code"
    t.string   "receiver_country_code"
    t.date     "shipping_datetime"
    t.date     "due_datetime"
    t.string   "num_of_pieces"
    t.string   "actual_weight"
    t.string   "product_group"
    t.string   "product_type"
    t.string   "description_of_goods"
    t.string   "goods_origin_country"
    t.string   "order_id"
    t.integer  "user_id"
    t.string   "order_number"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "receiver_refer"
    t.string   "shipment_refer"
    t.string   "shipper_refer"
    t.string   "receiver_post_code_required"
    t.string   "third_party_post_code_required"
    t.string   "shipper_phone_number"
    t.string   "shipper_tax_id_vat"
    t.string   "shipper_state"
    t.string   "receiver_phone_number"
    t.string   "receiver_tax_id_vat"
    t.string   "receiver_state"
  end

  add_index "shipments", ["order_id"], :name => "index_shipments_on_order_id"
  add_index "shipments", ["receiver_refer"], :name => "index_shipments_on_receiver_refer"
  add_index "shipments", ["shipment_refer"], :name => "index_shipments_on_shipment_refer"
  add_index "shipments", ["shipper_refer"], :name => "index_shipments_on_shipper_refer"
  add_index "shipments", ["user_id"], :name => "index_shipments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "shop_name"
    t.string   "shop_url"
    t.string   "account_country_code"
    t.string   "account_entity"
    t.string   "account_number"
    t.string   "account_pin"
    t.string   "email"
    t.string   "password"
    t.string   "shipper_name"
    t.string   "company_name"
    t.string   "cellphone"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.string   "remember_token"
    t.string   "shopify_email"
    t.string   "address_line1"
    t.string   "city"
    t.string   "post_code"
    t.string   "province"
    t.string   "country_code"
    t.string   "shopify_id"
    t.string   "currency_code"
    t.string   "default_domestic_product_type"
    t.string   "default_international_product_type"
    t.string   "default_prepaid_payment_option"
    t.string   "default_product_group"
    t.string   "default_payment_type"
    t.string   "user_refer"
    t.string   "default_domestic_services"
    t.string   "default_international_services"
    t.string   "allowed_cod",                                     :default => "no"
    t.string   "cod_account_number"
    t.string   "cod_account_pin"
    t.string   "cod_account_entity"
    t.string   "cod_account_country_code"
    t.string   "mode",                                            :default => "yes"
    t.string   "test"
    t.string   "tests",                                           :default => "0"
    t.string   "test1"
    t.string   "test2",                                           :default => "yes"
    t.string   "auto"
    t.integer  "auto1",                              :limit => 1
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["shop_url"], :name => "index_users_on_shop_url", :unique => true
  add_index "users", ["user_refer"], :name => "index_users_on_user_refer"

end
