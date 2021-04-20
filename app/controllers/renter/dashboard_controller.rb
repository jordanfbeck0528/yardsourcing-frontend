class Renter::DashboardController < ApplicationController
  def index
    @renter_yards_approved = DashboardFacade.renter_yards(current_user.id, 'approved')
  end
end
