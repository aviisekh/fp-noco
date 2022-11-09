class DashboardController < ApplicationController
  before_action :set_fp_generated_files, only: :submit_fp_csvs
  require 'jwt'

  METABASE_SITE_URL = "https://fleetpanda.metabaseapp.com"
  METABASE_SECRET_KEY = ENV["METABASE_SECRET_KEY"]
  
  def index 
    @scenario = Scenario.find_by(id: params[:scenario_id])
    @range=params[:date_range]
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
    ImportShiftReportFromFpJson.new(@fp_json_files, @fp_file_type).execute
    redirect_back(fallback_location: root_path)
  end

  private
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
