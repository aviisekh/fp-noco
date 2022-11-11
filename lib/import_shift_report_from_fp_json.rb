require 'csv'
class ImportShiftReportFromFpJson
  GH_API_KEY = ENV["GH_API_KEY"]

  def initialize(files, identifier, weekly = true)
    customer_file_path = Rails.root.join("public","customer_capacity.csv").to_s
    @files = files
    @identifier = identifier
    @weekly = weekly
    @customers_sizes = CSV.parse(File.read(customer_file_path), headers: true)
  end

  def execute
    @files.each do |f|
      json = JSON.load f.read
      rows = []
      columns = ["driver_id", "truck_id", "shift_date", "shift", "duration_hours", "deliveries", "volume", "distance", "delivery_time_minutes", "type", "cluster", "fill_rate"]
      unless @weekly
        rows = get_rows(json)
      else
        rows = get_weekly_rows(json)
      end
      ReportShift.import columns, rows
    end
  end

  def routes
    CSV.open("#{Rails.root}/public/routes_fp.csv", "wb") do |csv|
      csv << ["shift_date", "truck_id", "driver", "product", "volume", "service_time", "lat", "lon", "customer_pod", "address", "city", "state", "zip", "truck_lat", "truck_lon"]
      @files.each do |f|
        json = JSON.load f.read
        get_routes(json, csv)
      end
    end
  end

  private

  def get_routes(json, csv)
    json = json.with_indifferent_access

    shift_date = json[:weekKey].split('_')[0].to_date

    json[:fpClusters].each_key do |cluster_key|
      cluster = json.dig(:fpClusters, cluster_key)

      cluster[:paths].each_with_index do |base_path, index|

        truck_id = base_path.dig(:vehicle, :id)
        truck_lat = base_path.dig(:base, :lat).to_f
        truck_lon = base_path.dig(:base, :lon).to_f
        # driver_id = base_path.dig(:driver, :id)
        driver_id = index + 1

        base_path[:path].each do |path|
          amount = path.dig(:product, :amount).to_f
          product_name = path.dig(:product, :name)
          delivery_time = path.dig(:duration, :minutes).to_i
          lat = path.dig(:location, :lat).to_f
          lon = path.dig(:location, :lon).to_f
          customer_pod = path.dig(:location, :id)
          address = path.dig(:location, :place)
          city = path.dig(:location, :city)
          state = path.dig(:location, :state)
          zip = path.dig(:location, :zip)

          csv << [
            shift_date, truck_id, driver_id, product_name, amount, delivery_time, lat, lon,
            customer_pod, address, city, state, zip, truck_lat, truck_lon
          ]
        end
      end
    end
  end

  def get_weekly_rows(json)
    rows = []
    json = json.with_indifferent_access

    shift_date = json[:weekKey].split('_')[0].to_date
    json[:fpClusters].each_key do |cluster_key|
      cluster = json.dig(:fpClusters, cluster_key)
      cluster_id = cluster[:id]

      cluster[:paths].each_with_index do |base_path, index|
        # used_km = 0
        used_miles = base_path.dig(:toBase, :distanceTo).to_f
        used_time = base_path.dig(:toBase, :travelTime).to_f
        deliveries = 0
        volume = 0
        delivery_time = 0
        fill_rate = []

        truck_id = base_path.dig(:vehicle, :id)
        # driver_id = base_path.dig(:driver, :id)
        driver_id = index + 1

        origin = {
          lat: base_path.dig(:base, :lat),
          lon: base_path.dig(:base, :lon)
        }

        base_path[:path].each do |path|
          ori_lat = origin[:lat]
          ori_lon = origin[:lon]
          origin = {
            lat: path.dig(:location, :lat),
            lon: path.dig(:location, :lon)
          }
          dest_lat = origin[:lat]
          dest_lon = origin[:lon]
          # str_url = "#{base_url}origins=#{ori_lat}%2C#{ori_lon}&destinations=#{dest_lat}%2C#{dest_lon}&key=#{key}"
          # url = URI(str_url)

          # https = Net::HTTP.new(url.host, url.port)
          # https.use_ssl = true

          # request = Net::HTTP::Get.new(url)

          # response = https.request(request)
          # resp_res = JSON.load response.read_body
          # resp_res = resp_res.with_indifferent_access

          # used_km += resp_res[:rows][0][:elements][0][:distance][:value] / 1000
          # used_time += resp_res[:rows][0][:elements][0][:duration][:value].to_f / 60

          used_miles += path[:distanceTo].to_f
          used_time += path[:travelTime].to_f

          amount = path.dig(:product, :amount).to_f
          tank = @customers_sizes.select { |row| row['customer_pod'] == path.dig(:location, :id) }.first
          if tank
            fill_rate << (amount / tank['size_in_gallons'].to_f)
          end

          deliveries += 1
          volume += amount
          delivery_time += path.dig(:duration, :minutes).to_i
        end
        # csv << [driver_id, truck_id, shift_date, 1, used_time, deliveries, volume, (used_km * 0.621371), delivery_time, 'FP']
        rows << [truck_id, driver_id, shift_date, 1, (used_time/60.0), deliveries, volume, used_miles, delivery_time, @identifier, cluster_id, (fill_rate.sum(0.0) / fill_rate.size)]
      end
    end
    rows
  end

  def get_rows(json)
    rows = []
    json.each do |route|
      route = route.with_indifferent_access

      shift_date = route[:date].to_date


      route[:fpClusters].each do |cluster|

        cluster[:paths].each do |base_path|
          # used_km = 0
          used_miles = base_path.dig(:toBase, :distanceTo).to_f
          used_time = base_path.dig(:toBase, :travelTime).to_f
          deliveries = 0
          volume = 0
          delivery_time = 0

          truck_id = base_path.dig(:vehicle, :id)
          driver_id = base_path.dig(:driver, :id)

          origin = {
            lat: base_path.dig(:base, :lat),
            lon: base_path.dig(:base, :lon)
          }

          base_path[:path].each do |path|
            ori_lat = origin[:lat]
            ori_lon = origin[:lon]
            origin = {
              lat: path.dig(:location, :lat),
              lon: path.dig(:location, :lon)
            }
            dest_lat = origin[:lat]
            dest_lon = origin[:lon]
            # str_url = "#{base_url}origins=#{ori_lat}%2C#{ori_lon}&destinations=#{dest_lat}%2C#{dest_lon}&key=#{key}"
            # url = URI(str_url)

            # https = Net::HTTP.new(url.host, url.port)
            # https.use_ssl = true

            # request = Net::HTTP::Get.new(url)

            # response = https.request(request)
            # resp_res = JSON.load response.read_body
            # resp_res = resp_res.with_indifferent_access

            # used_km += resp_res[:rows][0][:elements][0][:distance][:value] / 1000
            # used_time += resp_res[:rows][0][:elements][0][:duration][:value].to_f / 60

            used_miles += path[:distanceTo].to_f
            used_time += path[:travelTime].to_f

            deliveries += 1
            volume += path.dig(:product, :amount).to_f
            delivery_time += path.dig(:duration, :minutes).to_i
          end
          # csv << [driver_id, truck_id, shift_date, 1, used_time, deliveries, volume, (used_km * 0.621371), delivery_time, 'FP']
          rows << [truck_id, driver_id, shift_date, 1, (used_time/60.0), deliveries, volume, used_miles, delivery_time, @identifier]
        end
      end
    end
    rows
  end
end
