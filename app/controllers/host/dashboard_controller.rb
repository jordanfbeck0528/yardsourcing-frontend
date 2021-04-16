class Host::DashboardController < ApplicationController
  def index
    @host_yards = EngineService.host_yards(current_user.id)
    if @host_yards.empty?
      @host_yards
    else
      @host_yards = @host_yards[:data]
    end
  end
end
