class YardsController < ApplicationController
  def show
    data = YardFacade.get_data(params[:id], current_user.id)
    @yard = data[:yard_details]
    @button_params = data[:button_params]
  end
end
