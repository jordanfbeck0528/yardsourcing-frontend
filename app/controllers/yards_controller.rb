class YardsController < ApplicationController
  def show
    @yard = YardFacade.yard_details(params[:id])
    @button_params = YardFacade.button_params(current_user.id)
  end
end
