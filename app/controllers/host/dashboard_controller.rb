class Host::DashboardController < ApplicationController
  def index
    @host_yards = EngineService.host_yards(current_user.id)
  end
end
