class ScenariosController < ApplicationController

  def index
    @scenarios = Scenario.all
  end

  def new
    @scenario = Scenario.new
  end

  def create
    @scenario = Scenario.new
    @scenario.attributes = scenario_params
    @scenario.save

    redirect_to :action => "index"
  end

  def edit
    @scenario = Scenario.find_by(id: params[:id])
  end

  def update
    @scenario = Scenario.find_by(id: params[:id])
    @scenario.attributes = scenario_params
    @scenario.save

    redirect_to :action => "index"
  end

  def destroy
    @scenario = Scenario.find_by(id: params[:id])
    @scenario.destroy

    redirect_to :action => "index"
  end

  private

  def scenario_params
    params.require(:scenario).permit(:name, :description)
  end 
end

