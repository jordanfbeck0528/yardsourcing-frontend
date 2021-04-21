class Host::DashboardController < ApplicationController
  def index
    facade = DashboardFacade.get_data(current_user.id)
    @host_yards = facade[:host_yards]
    @bookings = facade[:host_bookings]
  end
end
