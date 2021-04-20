class Renter::DashboardController < ApplicationController
  def index
    @renter_yards_approved = DashboardFacade.renter_yards(current_user.id, 'approved')
    @renter_yards_pending = DashboardFacade.renter_yards(current_user.id, 'pending')
  end
end
