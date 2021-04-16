class Host::DashboardController < ApplicationController
  def index
    info = EngineService.host_yards(current_user.id)
  end
end
