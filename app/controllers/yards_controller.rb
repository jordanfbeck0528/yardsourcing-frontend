class YardsController < ApplicationController
  def show
    @yard = YardFacade.yard_details(params[:id])
  end
end
