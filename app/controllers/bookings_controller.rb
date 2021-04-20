class BookingsController < ApplicationController
  def new
    data = YardFacade.get_data(params[:yard_id], current_user.id)
    @yard = data[:yard_details]
  end
end
