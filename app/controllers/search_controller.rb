class SearchController < ApplicationController
  before_action :set_purposes, only: [:index, :find_yards]

  def index
  end

  def find_yards
    downcase_params
    @data = YardFacade.yards_in_location(yard_params)
    
    if @data.yards.include?(:error)
      flash[:error] = @data.yards[:error]
      render :index, obj: @data.yards
    else
      render :find_yards
    end
  end

  private

  def yard_params
    params.permit(:location, purposes: [])
  end

  def downcase_params
    return [] unless params[:purposes]
    params[:purposes] = params[:purposes].map do |purpose|
      purpose.downcase
    end
  end
end
