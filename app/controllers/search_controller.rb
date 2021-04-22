class SearchController < ApplicationController
  before_action :set_purposes, only: [:index, :find_yards]

  def index
  end

  def find_yards
    downcase_params
    @yards = YardFacade.yards_in_location(yard_params)
    if @yards.include?(:error)
      flash[:error] = @yards[:error]
      redirect_to search_index_path
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
