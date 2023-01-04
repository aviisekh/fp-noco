class ScenariosController < ApplicationController

  def index
    @scenarios = Scenario.order(:id).all
  end

  def new
    if user_signed_in?
      @scenario = Scenario.new
    else
      redirect_to :action => "index"
    end
  end

  def create
    if user_signed_in?
      @scenario = Scenario.new
      @scenario.attributes = scenario_params
      @scenario.save
    end
    redirect_to :action => "index"
  end

  def edit
    if user_signed_in?
      @scenario = Scenario.find_by(id: params[:id])
    else
      redirect_to :action => "index"
    end
  end

  def update
    if user_signed_in?
      @scenario = Scenario.find_by(id: params[:id])
      @scenario.attributes = scenario_params
      @scenario.save
    end
    redirect_to :action => "index"
  end

  def destroy
    if user_signed_in?
      @scenario = Scenario.find_by(id: params[:id])
      @scenario.destroy
    end

    redirect_to :action => "index"
  end

  def show
    @scenario = Scenario.find_by(id: params[:id])
  end

  private

  def scenario_params
    params.require(:scenario).permit(:name, :description, :link, :version, :hours_saved, :miles_saved, :files, :date)
  end 
end

