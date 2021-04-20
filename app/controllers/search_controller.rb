class SearchController < ApplicationController
  before_action :set_purposes, only: [:index, :find_yards]

  def index
  end

  def find_yards
    if params[:purposes]
      downcase_params
    else
      @yards = YardFacade.yards_in_location(yard_params)
    end
    @yards = YardFacade.yards_in_location(yard_params)
    if @yards.include?(:error)
      flash[:error] = @yards[:error]
      render :index, obj: @purposes
    else
      render :find_yards
    end
  end

  private

  def yard_params
    params.permit(:location, purposes: [])
  end

  def downcase_params
    params[:purposes] = params[:purposes].map do |purpose|
      purpose.downcase
    end
  end
end
