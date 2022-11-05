# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bulk_storage_locations", id: false, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
  end

  create_table "completed_orders", id: false, force: :cascade do |t|
    t.string "slso_number"
    t.timestamptz "slso_date"
    t.string "slso_date_str"
    t.string "slstatus_long_desc"
    t.string "slso_abort_reason_id"
    t.string "slso_cust_id"
    t.string "slso_sut_shipto_id"
    t.string "slso_assigned_truck_id"
    t.string "slso_assigned_driver_id"
    t.date "slso_assigned_date"
    t.string "slso_assigned_date_str"
    t.date "slso_shift_date"
    t.string "slso_shift_date_str"
    t.string "slso_assigned_shift"
    t.string "slr_region"
    t.string "slso_back_office_original_so_number"
  end

  create_table "costs_estimates", id: false, force: :cascade do |t|
    t.integer "driver_id"
    t.string "truck_id"
    t.timestamptz "shift_date"
    t.integer "shift"
    t.string "product"
    t.timestamptz "start_time"
    t.timestamptz "end_time"
    t.float "distance"
    t.float "volume"
  end

  create_table "costs_estimates_2", id: false, force: :cascade do |t|
    t.integer "driver_id"
    t.string "truck_id"
    t.timestamptz "shift_date"
    t.integer "shift"
    t.string "product"
    t.timestamptz "start_time"
    t.timestamptz "end_time"
    t.float "distance"
    t.float "volume"
    t.float "fill_rate"
  end

  create_table "costs_estimates_3", id: false, force: :cascade do |t|
    t.integer "driver_id"
    t.string "truck_id"
    t.timestamptz "shift_date"
    t.integer "shift"
    t.string "product"
    t.timestamptz "start_time"
    t.timestamptz "end_time"
    t.float "distance"
    t.float "volume"
    t.float "fill_rate"
    t.float "minutes"
  end

  create_table "drivers", id: false, force: :cascade do |t|
    t.string "department"
    t.integer "employee_number"
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.string "oil"
    t.string "propane"
    t.time "start_time"
    t.string "start_time_str"
    t.time "end_time"
    t.string "end_time_str"
    t.string "notes"
  end

  create_table "geo_logs", id: false, force: :cascade do |t|
    t.integer "id"
    t.integer "sldlooh_corporate_id"
    t.integer "sldlooh_company_id"
    t.integer "sldlooh_division_id"
    t.integer "sldlooh_driver_id"
    t.integer "sldlooh_type"
    t.string "sldlooh_date_time_str"
    t.datetime "sldlooh_date_time", precision: nil
    t.string "sldlooh_truck_id"
    t.integer "sldlooh_shift"
    t.float "sldlooh_lat"
    t.float "sldlooh_lon"
    t.integer "sldlooh_register_1_totalizer"
    t.integer "sldlooh_register_2_totalizer"
    t.integer "sldlooh_register_3_totalizer"
    t.string "sldlooh_shift_date_str"
    t.date "sldlooh_shft_date"
    t.string "sldlooh_transaction_id"
    t.integer "sldlooh_region_id"
    t.integer "is_manually_entered"
    t.string "created_date_str"
    t.datetime "created_date", precision: nil
    t.string "modified_date_str"
    t.datetime "modified_date", precision: nil
    t.string "last_mofified_by"
  end

  create_table "gpm", id: false, force: :cascade do |t|
    t.string "pod"
    t.float "gallons"
    t.integer "minutes"
    t.float "gpm"
  end

  create_table "hris", id: false, force: :cascade do |t|
    t.integer "employee_number"
    t.string "employee_last_name"
    t.string "employee_first_name"
    t.string "pay_type_description"
    t.string "location"
    t.string "department"
    t.string "job"
    t.string "pay_period"
    t.string "pay_date_str"
    t.date "pay_date"
    t.string "pay_code"
    t.string "pay_category"
    t.float "hours"
    t.float "pay_amount"
    t.string "employee_pucnh_time_start"
    t.string "employee_pucnh_time_end"
    t.integer "hris_data_id"
  end

  create_table "inventory_workbench_events", id: false, force: :cascade do |t|
    t.timestamptz "date_time"
    t.string "date_time_str"
    t.string "type"
    t.string "id"
    t.string "description"
    t.string "source"
    t.string "destination"
    t.string "destination_st"
    t.string "bought_as"
    t.string "gnt_id"
    t.string "sold_as"
    t.string "sold_id"
    t.float "volume"
    t.float "pm_inv"
    t.float "dvr_inv"
    t.float "inv_diff"
    t.float "bookmarket"
    t.string "transaction_status"
    t.string "driver"
    t.date "shift_date"
    t.integer "shift"
    t.string "identity_id"
    t.string "alt_id"
    t.string "hight"
    t.timestamptz "date_time_sort"
    t.string "date_time_sort_str"
    t.string "reviewed"
    t.integer "source_id"
    t.integer "target_id"
    t.string "source_id2"
    t.string "target_id2"
    t.string "is_ebol_verified"
    t.string "is_ebol_verified_explanatory_text"
    t.float "status_code"
    t.string "sod"
    t.timestamptz "approval_date"
    t.string "approval_date_str"
    t.string "approval_name"
    t.timestamptz "posted_date"
    t.string "posted_date_str"
    t.string "bill_type"
    t.string "warehouse_id"
    t.string "non_bulk"
    t.string "manually_added"
    t.string "driver_hist_type"
    t.string "driver_id"
    t.string "pump_charge"
    t.string "demurrage"
    t.string "reason_code_id"
    t.string "reason_code_desc"
    t.string "soc_demurrage"
    t.string "assoc_demurrage_reason_desc"
    t.string "assoc_bol_transaction_id"
    t.string "images"
    t.string "notes"
    t.string "freight"
    t.string "delivery_fee"
    t.float "price"
    t.string "price_per"
  end

  create_table "miliage_data", id: false, force: :cascade do |t|
    t.date "tran_date"
    t.string "route_id"
    t.float "distance"
  end

  create_table "miliage_data_2", id: false, force: :cascade do |t|
    t.integer "id"
    t.string "tran_date_str"
    t.date "tran_date"
    t.string "route_id"
    t.float "distance"
    t.string "started_date_str"
    t.datetime "started_date", precision: nil
    t.string "departed_date_str"
    t.datetime "departed_date", precision: nil
    t.string "arrived_date_str"
    t.datetime "arrived_date", precision: nil
    t.string "completed_date_str"
    t.datetime "completed_date", precision: nil
  end

  create_table "nav_completed_orders", id: false, force: :cascade do |t|
    t.string "document_no"
    t.timestamptz "posting_date"
    t.string "posting_date_str"
    t.timestamptz "delivery_date"
    t.string "delivery_date_str"
    t.string "customer_posting_group"
    t.string "delivery_ref_no"
    t.string "bill_to_customer_no"
    t.string "customer_pod"
    t.string "shipto_address"
    t.string "shipto_address2"
    t.string "shipto_city"
    t.string "shipto_state"
    t.string "shipto_zip"
    t.integer "zero_gallons_delivery"
    t.string "gen_bus_position_group"
    t.string "delivery_zone"
    t.string "delivery_center"
    t.string "item_no"
    t.string "description"
    t.float "quantity"
    t.string "unit_of_measure"
    t.string "type"
    t.integer "ideal_in_gallons"
    t.integer "size_in_gallons"
    t.string "fuel_forecast_method"
  end

  create_table "nav_sales_header", id: false, force: :cascade do |t|
    t.string "document_no"
    t.timestamptz "posting_date"
    t.timestamptz "delivered_date"
    t.string "customer_posting_group"
    t.string "customer_pod"
    t.string "delivery_ref_no"
    t.string "delivery_zone"
    t.string "deliver_mgmt_no"
    t.integer "bill_to_customer_no"
    t.string "bill_to_zip"
    t.string "ship_to_address"
    t.string "ship_to_address2"
    t.string "ship_to_city"
    t.string "ship_to_state"
    t.string "ship_to_zip"
    t.integer "zero_gallon_delivery"
    t.string "delivery_center"
    t.string "documentno", limit: 10
    t.string "postingdate", limit: 18
    t.string "delivereddate", limit: 18
    t.string "customerpostinggroup", limit: 10
    t.string "customerpod", limit: 10
    t.string "deliveryrefno", limit: 11
    t.string "deliveryzone", limit: 5
    t.string "delivermgmtno", limit: 9
    t.integer "billtocustomerno"
    t.integer "billtozip"
    t.string "shiptoaddress", limit: 175
    t.string "shiptoaddress2", limit: 47
    t.string "shiptocity", limit: 19
    t.string "shiptostate", limit: 11
    t.string "shiptozip", limit: 2
    t.integer "zerogallondelivery"
    t.string "deliverycenter", limit: 8
  end

  create_table "planned_orders", id: false, force: :cascade do |t|
    t.string "slso_number"
    t.date "slso_date"
    t.string "slso_date_str"
    t.string "slstatus_long_desc"
    t.string "slso_cust_id"
    t.string "slso_cust_shipto_id"
    t.string "slso_assigned_truck_id"
    t.string "slso_assigned_driver_id"
    t.string "slso_asssigned_date"
    t.integer "slso_assigned_shift_id"
    t.string "slr_region"
    t.string "slsl_backoffice_original_so_number"
    t.string "sl_cust_shipto_address_1"
    t.string "sl_cust_shipto_city"
    t.string "sl_cust_shipto_state"
    t.string "sl_cust_shipto_zip"
    t.float "sl_cust_shipto_lat"
    t.float "sl_cust_shipto_lon"
  end

  create_table "pod_info", id: false, force: :cascade do |t|
    t.integer "customer_no"
    t.integer "no"
    t.string "address"
    t.string "address2"
    t.string "city"
    t.string "zip_code"
    t.string "province"
    t.integer "blocked"
    t.integer "active_item_no"
    t.string "customer_pod"
    t.string "customer_tank_tax_type"
    t.boolean "inactive"
    t.string "fuels_forecast_method"
    t.integer "ideal_in_gallons"
    t.integer "size_in_gallons"
    t.string "hh_order_type"
    t.string "delivery_zone"
    t.integer "usable_in_gallons"
  end

  create_table "ref_driver_location", id: false, force: :cascade do |t|
    t.string "sky_blitz_num"
    t.string "employee_last_name"
    t.string "employee_first_name"
    t.string "bulk_storage_location"
  end

  create_table "ref_driver_location_2", id: false, force: :cascade do |t|
    t.string "employee_number"
    t.string "sky_blitz_no"
    t.string "last_name"
    t.string "first_name"
    t.string "location"
  end

  create_table "ref_truck_master", id: false, force: :cascade do |t|
    t.string "vehicle_number"
    t.string "make"
    t.string "type1"
    t.string "state"
    t.string "gvw"
    t.string "location"
    t.string "service_type"
    t.integer "tank_capacity"
    t.string "relay_device_num"
    t.string "flush_amt_gals"
    t.string "amt_per_gals"
    t.string "comp1"
    t.string "comp2"
    t.string "comp3"
    t.string "comp4"
  end

  create_table "ref_truck_master2", id: false, force: :cascade do |t|
    t.string "vehicle_number"
    t.string "make"
    t.string "type1"
    t.string "state"
    t.string "gvw"
    t.string "location"
    t.string "service_type"
    t.integer "tank_capacity"
    t.string "relay_device_num"
    t.string "flush_amt_gals"
    t.string "amt_per_gals"
    t.integer "meters"
    t.integer "comp1"
    t.integer "comp2"
    t.integer "comp3"
    t.integer "comp4"
    t.integer "total"
    t.string "product_type"
    t.string "notes"
  end

  create_table "report_shifts", id: false, force: :cascade do |t|
    t.integer "driver_id"
    t.string "truck_id"
    t.date "shift_date"
    t.integer "shift"
    t.float "duration_hours"
    t.integer "deliveries"
    t.float "volume"
    t.float "distance"
    t.float "delivery_time_minutes"
    t.string "type"
    t.string "shift_date_str"
    t.integer "loadings"
    t.float "fill_rate"
    t.float "hours_overtime"
    t.float "hris_hour"
  end

  create_table "shifts_start_end_location", id: false, force: :cascade do |t|
    t.string "truck_id"
    t.integer "driver_id"
    t.date "shift_date"
    t.integer "shift"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.float "lat_start"
    t.float "lon_start"
    t.float "lat_end"
    t.float "lon_end"
  end

  create_table "smart_logic_data_1", id: false, force: :cascade do |t|
    t.string "type"
    t.integer "driver_id"
    t.string "delivery_id"
    t.string "truck_id"
    t.timestamptz "shift_date"
    t.string "shift_date_str"
    t.integer "shift"
    t.timestamptz "transaction_date"
    t.string "transaction_date_str"
    t.string "smart_logix_data_id"
    t.string "source"
    t.string "bought_id"
    t.string "bought_as"
    t.string "sold_id"
    t.string "sold_as"
    t.string "target_id"
    t.float "volume"
    t.string "shipto_address"
    t.string "shipto_address2"
    t.string "shipto_city"
    t.string "shipto_state"
    t.string "shipto_zip"
    t.string "delivery_zone"
    t.string "delivery_center"
    t.integer "zero_gallons_delivery"
  end

  create_table "smart_logic_data_2", id: false, force: :cascade do |t|
    t.string "type"
    t.integer "driver_id"
    t.string "delivery_id"
    t.string "truck_id"
    t.timestamptz "shift_date"
    t.string "shift_date_str"
    t.integer "shift"
    t.string "transaction_date_str"
    t.string "smart_logix_data_id"
    t.string "source"
    t.string "bought_id"
    t.string "bought_as"
    t.string "sold_id"
    t.string "sold_as"
    t.string "target_id"
    t.float "volume"
    t.float "slsod_delivered_lat"
    t.float "slsod_delivered_lon"
    t.timestamptz "slsod_delivery_start_date_time"
    t.string "slsod_delivery_start_date_time_str"
    t.timestamptz "slsod_delivery_date_time"
    t.string "slsod_delivery_date_time_str"
    t.datetime "transaction_date", precision: nil
  end

  create_table "smart_logic_data_2_nd", id: false, force: :cascade do |t|
    t.integer "driver_id"
    t.string "truck_id"
    t.date "shift_date"
    t.integer "shift"
    t.string "type"
    t.string "sold_as"
    t.string "delivery_id"
    t.datetime "slsod_delivery_start_date_time", precision: nil
    t.datetime "slsod_delivery_date_time", precision: nil
  end

  create_table "smart_logic_data_2_transactions", id: false, force: :cascade do |t|
    t.integer "smart_logic_id"
    t.string "shift_date_str"
    t.date "shift_date"
    t.string "transaction_time_str"
    t.datetime "transaction_time", precision: nil
  end

  create_table "tank_monitors", id: false, force: :cascade do |t|
    t.string "processed"
    t.string "processed_datetime_str"
    t.datetime "processed_datetime", precision: nil
    t.string "error_message"
    t.integer "customer_id"
    t.string "base_id"
    t.integer "tx_no"
    t.integer "capacity"
    t.integer "tank_level"
    t.string "report_date_str"
    t.datetime "report_date", precision: nil
    t.string "location"
    t.string "access"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "route"
    t.string "cart1"
    t.string "last_fill_str"
    t.datetime "last_fill", precision: nil
    t.integer "last_fill_level"
    t.integer "days_empty"
    t.float "dau"
    t.integer "base_temp"
    t.integer "stop"
    t.string "customer_pod"
  end

  create_table "tank_size_assets", id: false, force: :cascade do |t|
    t.string "unit"
    t.string "vin"
    t.string "category"
    t.integer "year"
    t.string "make"
    t.string "type"
    t.integer "size"
    t.integer "comp1"
    t.integer "comp2"
    t.integer "comp3"
    t.integer "comp4"
    t.integer "comp5"
    t.string "make2"
    t.string "rim_tire"
    t.string "were"
    t.string "meters"
    t.string "hose"
    t.string "note"
  end

  create_table "tank_size_bobtail", id: false, force: :cascade do |t|
    t.string "unit"
    t.string "vin"
    t.integer "year"
    t.string "make"
    t.string "type"
    t.integer "size"
    t.integer "comp1"
    t.string "make2"
    t.string "rim_tire"
    t.string "were"
  end

  create_table "tank_size_trailer", id: false, force: :cascade do |t|
    t.string "unit"
    t.string "vin"
    t.integer "year"
    t.string "make"
    t.integer "size"
    t.integer "comp1"
    t.integer "comp2"
    t.integer "comp3"
    t.integer "comp4"
    t.integer "comp5"
    t.string "rim_tire"
    t.string "note"
  end

  create_table "tank_size_trucks", id: false, force: :cascade do |t|
    t.integer "unit"
    t.string "vin"
    t.integer "year"
    t.string "make"
    t.integer "size"
    t.integer "comp1"
    t.integer "comp2"
    t.integer "comp3"
    t.integer "comp4"
    t.string "make2"
    t.string "rim_tire"
    t.string "was"
    t.integer "meters"
    t.integer "hose"
  end

  create_table "truck_locations", id: false, force: :cascade do |t|
    t.string "location"
    t.float "lat"
    t.float "lon"
  end

end
