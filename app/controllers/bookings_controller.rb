class BookingsController < ApplicationController
  before_action :set_yard, only: [:new, :create]

  def create
    params[:renter_id] = current_user.id
    params[:renter_email] = current_user.email
    booking = EngineService.create_booking(booking_params)
    if booking.include?(:error)
      flash[:error] = booking[:error]
      render :new, obj: @yard
    else
      redirect_to renter_dashboard_index_path
    end
  end

  private

  def booking_params
    params.permit(:renter_id, :renter_email, :yard_id, :booking_name, :date, :time, :duration, :description)
  end

  def set_yard
    data = YardFacade.get_data(params[:yard_id], current_user.id)
    @yard = data[:yard_details]
  end
end
