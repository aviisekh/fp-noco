class DashboardController < ApplicationController
  require 'jwt'

  METABASE_SITE_URL = "https://fleetpanda.metabaseapp.com"
  METABASE_SECRET_KEY = ENV["METABASE_SECRET_KEY"]
  
  def index 
    if (chart_params["date_range"].blank? || chart_params["type"].blank? ) 
      redirect_to root_path(params: {date_range: "2021-11-01~2021-11-10", type: "NOCO2,FP3"})
    end
    
    payload = {
      :resource => {:dashboard => 324},
      :params => chart_params,
      :exp => Time.now.to_i + (60 * 10) # 10 minute expiration
    }
    token = JWT.encode payload, METABASE_SECRET_KEY
    
    @iframe_url = METABASE_SITE_URL + "/embed/dashboard/" + token + "#bordered=true&titled=true"
  end

  private
  def chart_params 
    {
      "date_range" => params[:date_range],
      "type" => params[:type]&.split(",")
    }
  end 
end
