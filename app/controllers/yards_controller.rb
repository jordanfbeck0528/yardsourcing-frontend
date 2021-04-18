class YardsController < ApplicationController

  def show
    @yard = YardsFacade.yard_details(params[:id])
    @button_params = YardsFacade.button_params(current_user.id)
  end
end
