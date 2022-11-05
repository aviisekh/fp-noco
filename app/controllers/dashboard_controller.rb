class DashboardController < ApplicationController
  require 'jwt'

  METABASE_SITE_URL = "https://fleetpanda.metabaseapp.com"
  METABASE_SECRET_KEY = ENV["METABASE_SECRET_KEY"]
  
  def index 
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
      "text_contains" => params[:text].split(",")
    }
  end 
end
