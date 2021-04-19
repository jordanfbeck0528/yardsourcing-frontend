class YardsController < ApplicationController
  def show
    data = YardFacade.get_data(params[:id], current_user.id)
    @yard = data[:yard_details]
    @button_params = data[:button_params]

    if @yard.empty?
      flash[:error] = 'Data cannot be accessed at this time'
      redirect_to host_dashboard_index_path
    end
  end
end
