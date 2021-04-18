class YardsController < ApplicationController

  def show
    @yard = EngineService.yard_details(params[:id])
  end
end
