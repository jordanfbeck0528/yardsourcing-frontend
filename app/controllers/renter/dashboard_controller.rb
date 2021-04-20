class Renter::DashboardController < ApplicationController
  def index
    @renter_yards_approved = DashboardFacade.renter_yards(current_user.id, 'approved')
    binding.pry
  end
end
