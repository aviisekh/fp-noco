require 'csv'
class ImportShiftReportFromFpJson
  GH_API_KEY = ENV["GH_API_KEY"]

  def initialize(files, identifier)
    @files = files
    @identifier = identifier
  end

  def execute
    @files.each do |f|
      json = JSON.load f.read
      columns = ["driver_id", "truck_id", "shift_date", "shift", "duration_hours", "deliveries", "volume", "distance", "delivery_time_minutes", "type"]
      rows = get_rows(json)
      ReportShift.import columns, rows
    end
  end

  private
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
