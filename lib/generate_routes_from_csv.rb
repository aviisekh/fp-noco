require 'csv'
class GenerateRoutesFromCsv
  GH_API_KEY = ENV["GH_API_KEY"]

  def initialize(from_date=nil, number_of_days=0)
    from_date = (from_date || '2021-12-01').to_date
    to_date = from_date + number_of_days.days
    routes_file_path =  Rails.root.join("public","all_routes.csv").to_s
    trucks_file_path =  Rails.root.join("public","trucks.csv").to_s
    
    @output_path = "#{Rails.root}/public/graphhopper_results"
    @date_range = (from_date..to_date).to_a
    @identifier = "GH20221103204537"
    
    @routes_data = CSV.parse(File.read(routes_file_path), headers: true)
    @trucks_data = CSV.parse(File.read(trucks_file_path), headers: true)
  end

  def execute
    @date_range.each do |date|
      puts "==== For date #{date.to_s} ====="
      selected = @routes_data.select { |row| row['shift_date'].to_date == date.to_date && row['type'] == 'Delivery' }
      groups = {}
      selected.each do |row|
        if groups[row['truck_location']]
          groups[row['truck_location']].push row
        else
          groups[row['truck_location']] = [row]
        end
      end

      routes_results = []
      groups.keys.each do |location|
        puts "For Location #{location}"

        # td = @trucks_data.select { |row|  row['location'].downcase == location.downcase && row['product_type'] == 'Propane' }
        td = []
        groups[location].each do |r|
          next if td.select { |row| row['truck_id'] == r['truck_id'] }.size > 0

          td << {
            truck_id: r['truck_id'],
            first_route: r,
            truck: @trucks_data.select { |row| row['vehicle_number'] == r['truck_id'] }
          }.with_indifferent_access
        end
        json_data = {
          vehicles: graphhopper_vehicles(td),
          vehicle_types: graphhopper_vehicle_types(td),
          services: graphhopper_delivery_services(groups[location]),
          objectives: graphhopper_objectives,
          configuration: graphhopper_configuration
        }
        
        response = HTTParty.post(
          "https://graphhopper.com/api/1/vrp?key=#{GH_API_KEY}",
          body: json_data.to_json,
          headers: {'Content-Type' => 'application/json'}
        )
        routes_results << {
          request: json_data,
          response: response
        }
        # break
        sleep(1.minute)
      end

      write_graphhopper_request_response(routes_results, date)
      # write_database_csv(routes_results, date)
      write_data_to_noco_db(routes_results,date)
      # break
    end
  end

  private

  def write_data_to_noco_db(routes_results, date)
    cols = ['driver_id', 'truck_id', 'shift_date', 'shift_date_str', 'shift', 'duration_hours', 'deliveries', 'volume', 'distance', 'delivery_time_minutes', 'type']
    values = graphhopper_response_normalized(routes_results, date)

    puts "Writing the rows in db"
    ReportShift.import cols, values
  end

  def write_database_csv(routes_results, date)
    puts "Writing to database file format"
    CSV.open("#{@output_path}_#{date}.csv", "wb") do |csv|
      csv << ["driver_id", "truck_id", "shift_date", "shift_date_str", "shift", "duration", "deliveries", "volume", "distance", "delivery_time", "type"]
      graphhopper_response_normalized(routes_results, date).each do |row|
        csv<< row
      end
    end
  end

  def write_graphhopper_request_response(routes_results, date)
    puts "Writing to request_response file format"
    File.open(Rails.root.join("#{@output_path}_#{date}.json"),"w") do |f|
      f.write(routes_results.to_json)
    end
  end

  def graphhopper_response_normalized(routes_results, date)
    data = []
    routes_results.as_json.each do |json|
      json = json.with_indifferent_access
      if json[:response][:solution]
        json[:response][:solution][:routes].each_with_index do |route, index|
          driver = index + 1
          truck = route[:vehicle_id]
          shift = 1
          duration = route[:completion_time] / 3600.0
          deliveries = route[:activities].select { |row| row[:type] == 'delivery' }.size
          volume = route[:activities].select { |row| row[:type] == 'start' }.first[:load_after].first.to_f
          distance = route[:distance] * 0.000621371
          delivery_time = route[:service_duration] / 60.0

          data << [
            driver, truck, date, date, shift, duration, deliveries, volume, distance, delivery_time, @identifier
          ]
        end
      end
    end
    data
  end

  def graphhopper_vehicles(td)
    td.map do |truck_data|
      {
        "vehicle_id": truck_data['truck_id'],
        "type_id": "#{truck_data['truck_id']}-#{truck_data['truck'][0]['type1']}",
        "start_address": {
          "location_id": truck_data['truck'][0]['location'] + '-' + truck_data['truck'][0]['state'],
          "lon": truck_data['first_route']['truck_start_location_lon'].to_f,
          "lat": truck_data['first_route']['truck_start_location_lat'].to_f
        },
        "end_address": {
          "location_id": truck_data['truck'][0]['location'] + '-' + truck_data['truck'][0]['state'],
          "lon": truck_data['first_route']['truck_start_location_lon'].to_f,
          "lat": truck_data['first_route']['truck_start_location_lat'].to_f
        },
        "skills": ['PROPANE']
      }
    end
  end

  def graphhopper_vehicle_types(td)
    td.map do |truck_data|
      {
        "type_id": "#{truck_data['truck_id']}-#{truck_data['truck'][0]['type1']}",
        "profile": 'Truck',
        "capacity": [truck_data['truck'][0]['tank_capacity'].to_i]
      }
    end.uniq
  end

  def graphhopper_delivery_services(data)
    keys = {}
    data.map do |shipto|
      unique_key = shipto['customer_pod'] + '-' + shipto['product'] + '-' + shipto['volume'].to_i.to_s
      unless keys[unique_key]
        keys[unique_key] = 1
      else
        keys[unique_key] += 1
      end
      {
        "id": "#{keys[unique_key]} - #{unique_key}",
        "type": "delivery",
        "name": "deliver at #{shipto['customer_pod']}",
        "address": {
          "location_id": "#{shipto['volume'].to_i}-#{shipto['customer_pod']}",
          "lon": shipto['slsod_delivered_lon'].to_f,
          "lat": shipto['slsod_delivered_lat'].to_f
        },
        "size": [shipto['volume'].to_i],
        "duration": (shipto['delivery_end'].to_time - shipto['delivery_start'].to_time).to_i,
        "required_skills": ['PROPANE']
      }
    end
  end

  def graphhopper_objectives
    [
      {
        "type": "min",
        "value": "completion_time"
      }
    ]
  end

  def graphhopper_configuration
    {
      "routing": {
        "calc_points": true
      }
    }
  end

end
