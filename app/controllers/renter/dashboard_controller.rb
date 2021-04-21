class Renter::DashboardController < ApplicationController
  def index
    data = DashboardFacade.get_bookings_by_status(current_user.id)

    @renter_bookings_approved = data[:approved_bookings]
    @renter_bookings_pending = data[:pending_bookings]
  end
end
