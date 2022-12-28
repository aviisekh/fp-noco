class DashboardController < ApplicationController
  before_action :set_fp_generated_files, only: :submit_fp_csvs
  before_action :totals, only: :index
  require 'jwt'

  METABASE_SITE_URL = 'https://fleetpanda.metabaseapp.com'
  METABASE_SECRET_KEY = ENV['METABASE_SECRET_KEY']

  def index
    @scenario = Scenario.find_by(id: params[:scenario_id])
    @range = params[:date_range]
    if (chart_params["date_range"].blank? || chart_params["type"].blank? ) 
      redirect_to root_path(params: {date_range: "2021-11-01~2021-11-10", type: "NOCO2,FP3"})
    end

    payload = {
      :resource => {:dashboard => 324},
      :params => chart_params,
      :exp => Time.now.to_i + (60 * 10) # 10 minute expiration
    }
    token = JWT.encode payload, METABASE_SECRET_KEY

    @iframe_url = METABASE_SITE_URL + "/embed/dashboard/" + token + "#bordered=true&titled=false"
  end

  def upload_fp_csvs
    @available_types = ReportShift.pluck(:type).uniq.to_s
  end

  def submit_fp_csvs
    # ImportShiftReportFromFpJson.new(@fp_json_files, @fp_file_type).execute
    ImportShiftReportFromFpJson.new(@fp_json_files, @fp_file_type).routes
    redirect_back(fallback_location: root_path)
  end

  private

  def totals
    types = params[:type].split(',')
    return build_totals_variables(types) if types.size == 2

    @totals_data = {}
  end

  def build_totals_variables(types)
    @totals_data = {}
    dates = params[:date_range].split('~').map(&:to_date)
    types.each do |key|
      @totals_data[key] = {}
      values = ReportTotal.where(report_type: key, shift_date: dates[0]..dates[1]).group(:report_type)
      select_fields = []
      %w[total_hours deliveries total_volume total_miles total_time_delivery fill_rate speed
        vol_per_miles volume_per_delivery vol_per_hour_worked delivery_hour delivery_day total_returns
      ].each do |field|
        if field == 'volume_per_delivery'
          select_fields << "sum(total_volume)/sum(NULLIF(deliveries, 0)::double precision) as #{field}"
        elsif field == 'vol_per_miles'
          select_fields << "sum(total_volume)/sum(NULLIF(total_miles, 0)::double precision) as #{field}"
        elsif field == 'vol_per_hour_worked'
          select_fields << "sum(total_volume)/sum(NULLIF(total_hours, 0)::double precision) as #{field}"
        elsif field == 'delivery_hour'
          select_fields << "sum(deliveries::double precision)/sum(NULLIF(total_hours, 0)::double precision) as #{field}"
        elsif field == 'delivery_day'
          select_fields << "sum(deliveries::double precision)/sum(NULLIF(number_days, 0)) as #{field}"
        elsif sum_field?(field)
          # @totals_data[key][field] = values.sum(field)[key]
          select_fields << "sum(#{field}) as #{field}" 
        else
          # @totals_data[key][field] = values.average(field)[key]
          select_fields << "avg(#{field}) as #{field}" 
        end
      end
      values = values.select(select_fields.join(', ')).first
      %w[total_hours deliveries total_volume total_miles total_time_delivery fill_rate speed
        vol_per_miles volume_per_delivery vol_per_hour_worked delivery_hour delivery_day total_returns
      ].each do |field|
        @totals_data[key][field] = values.send(field)
      end
    end
    @totals_data['delta'] = {}
    %w[total_hours deliveries total_volume total_miles total_time_delivery fill_rate speed
        vol_per_miles volume_per_delivery vol_per_hour_worked delivery_hour delivery_day total_returns
      ].each do |field|
      @totals_data['delta'][field] =
        @totals_data[types[0]][field].to_f - @totals_data[types[1]][field].to_f
    end

  end

  def sum_field?(field)
    %w[total_hours deliveries total_volume total_miles total_time_delivery total_returns].include? field
  end

  def chart_params
    {
      "date_range" => params[:date_range],
      "type" => params[:type]&.split(",")
    }
  end 


  def set_fp_generated_files 
    @fp_json_files = params[:fp_json_files][:fp_file].compact_blank
    @fp_file_type = params[:fp_json_files][:fp_file_type]
  end 

end
