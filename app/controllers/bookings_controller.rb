class BookingsController < ApplicationController
  def new
    data = YardFacade.get_data(params[:yard_id], current_user.id)
    @yard = data[:yard_details]
  end

  def create
    params[:renter_id] = current_user.id
    params[:renter_email] = current_user.email
    booking = EngineService.create_booking(booking_params)
    if booking.include?(:error)
      binding.pry
      flash[:error] = booking[:error]
    else
      redirect_to renter_dashboard_index_path
    end
  end

  private

  def booking_params
    params.permit(:renter_id, :renter_email, :yard_id, :booking_name, :date, :time, :duration, :description)
  end
end
