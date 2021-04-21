class YardsController < ApplicationController
  def show
    @yard = YardFacade.yard_details(params[:id])
    if @yard.empty?
      flash[:error] = 'Data cannot be accessed at this time'
      redirect_to host_dashboard_index_path
    end
  end
end
